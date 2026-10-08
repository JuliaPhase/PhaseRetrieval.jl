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
