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
