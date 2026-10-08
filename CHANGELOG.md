# Changelog

All notable changes to PhaseRetrieval.jl are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- `strehl_exposure(conf; vectorial)` — exposure that images the peak of the aberration-free
  PSF of `conf` (same aperture and apodisation, scalar or vectorial channels) as 1, so that the
  images are in units of the Strehl ratio, as the "relative intensity" of Zemax. Unlike
  `FixedExposure(conf)` (the scalar peak |Σ ap|²) it does not clip vectorial PSFs, whose peak
  exceeds |Σ ap|² (obliquity factor cos^(−1/2) ≥ 1, two input polarisations for the random one).
- `CHANGELOG.md` — started tracking changes following Keep a Changelog format
- `.github/copilot-instructions.md` — added project context for GitHub Copilot (key types, exported functions, relationships, source layout)

