# PhaseRetrieval — TODO

## Describe the exposures in the tutorial (priority: high)

Add to `tutorials/Hardware.jl` (camera and exposure) a section on the exposures:
`AutoExposure` (the peak of every frame at the given level), `FixedExposure` (one scale for all
frames; `FixedExposure(conf)` is the peak |Σ ap|² of the aberration-free *scalar* PSF) and
`strehl_exposure(conf; vectorial)` (images in units of the Strehl ratio, as Zemax). Show that
`FixedExposure(conf)` clips a vectorial PSF near the focus (the obliquity factor cos^(−1/2) ≥ 1
and, for random polarisation, the sum of the two input polarisations raise the peak above
|Σ ap|²), and that `strehl_exposure` gives peak 1 for the aberration-free PSF in focus and the
Strehl ratio otherwise. Found on 2026-10-08 in the 14AMI simulations (Feedback14AMI
`generate_psfs` now defaults to `strehl_exposure`).

## Rewrite `binning` without intermediate arrays; rectangular cells (priority: low)

`binning(arr, Q)` (`src/utils.jl`) allocates about 6 times its output: the crop
`arr[1:mQ, 1:nQ]` is a full copy, `sum(B; dims=(1, 3))` a second array, and `./ Q^2` a third.
Measured 2026-10-09 (Julia 1.12) against a plain loop that allocates only the output
(`@inbounds for j in 1:n, q2 in 1:Q, i in 1:m, q1 in 1:Q; out[i, j] += arr[(i-1)Q+q1, (j-1)Q+q2]`,
then `out ./= Q^2`), same results:

| input              | binning           | loop             |
|--------------------|-------------------|------------------|
| Float64 201×201    | 104 μs, 469 KiB   | 37 μs, 78 KiB    |
| N0f8 691×691       | 907 μs, 2325 KiB  | 710 μs, 930 KiB  |
| Float64 2048×2048  | 15.1 ms, 48 MiB   | 5.7 ms, 8 MiB    |

To do: a non-allocating `binning!(out, arr, Q)` and `binning(arr, Q)` = allocate the output and
call it; accumulator type as now (`Base.add_sum` of the element type, so `N0f8` → Float64,
`Float32` stays Float32, Int → Float64 after the division); a view instead of the crop copy if a
reshape-based version is kept. Also cells `(Qy, Qx)` for anisotropic pixels (e.g. 14AMI VF02:
66.6 × 14.42 nm, the rows are 4.85 times oversampled) and the matching `binning(::CameraChip, (ny, nx))`.
Not urgent: for the frame sizes of 14AMI and AMAT the cost is negligible next to a solve.
Found while adding `bin_frames` to Feedback14AMI (AMAT 2019 data, NA 0.5, 45 nm pixel).

## Learn from or use PointSpreadFunctions.jl (later)

Rainer Heintzmann's PointSpreadFunctions.jl (example and notes in
`14AMI/Codebase/VectorialPSF_generators/PointSpreadFunctions.jl/example_from_github_repo/demo_oleg.jl`)
is well written and fast. It computes vectorial PSFs by several methods (Richards–Wolf, angular
spectrum propagation with PML, SincR, CZT) with an explicit aplanatic factor
(`aplanatic_detection` = cos^(−1/2), our model; `aplanatic_illumination` = cos^(1/2),
`aplanatic_const`, `aplanatic_illumination_flux`), polarisations, aberrations, pixel shape and
wavelength weights. Either learn from its implementation (speed, z-stacks, the choice of the
aplanatic factor as an option) or use it as a forward model / cross-check. On the Zemax PSFs of
2018 (14AMI `demo-book/zemax-inverse-Aug2018.qmd`) our vectorial model with cos^(−1/2) fits
best; an option for the aplanatic factor in PhaseRetrieval would make such checks part of the API.
