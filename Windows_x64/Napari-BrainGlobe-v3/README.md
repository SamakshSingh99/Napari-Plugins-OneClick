# BrainGlobe with Atlas API v3 — Windows x64

This package installs the official complete BrainGlobe 3.0.0 tool suite with
BrainGlobe Atlas API 3.0.1 in an isolated `brainglobe-v3` Conda environment.
It creates a **BrainGlobe v3** Desktop shortcut.

The installer uses the official `brainglobe==3.0.0` metapackage and locks the
suite components: brainreg, segmentation, cellfinder, brainrender,
brainrender-napari, heatmaps, utilities, spatial conventions, and napari I/O.

## Install

1. Use 64-bit Windows 10 or 11 and install Anaconda or Miniconda.
2. Keep the `.bat` and `.yaml` files together.
3. Double-click **Install BrainGlobe v3.bat**.
4. Wait for the dependency and import checks to complete.
5. Open **BrainGlobe v3** from the Desktop and use napari's **Plugins** menu.

Atlas API v3 uses OME-Zarr and obtains components from AWS S3 on first access,
so internet access is required. High-resolution atlases can need substantial
memory and disk space. `atlas.reference` is deprecated; use `atlas.template`
in new scripts.

`brainglobe-workflows` is a separate optional package rather than part of the
metapackage suite. Rerunning the installer repairs the suite to recorded versions.

If an earlier or interrupted installation left the environment unable to import
`_ctypes`, revision 5 detects the damaged Python runtime and automatically
rebuilds only the `brainglobe-v3` environment. It uses a dedicated fresh package
cache and strict conda-forge packages so a damaged shared Conda cache is not
reused. Conda installs `libffi`, vedo, and VTK before pip runs. The other Conda
environments and user data are not removed. Repeated `truststore`, Rich, or
`vedo` errors can be secondary symptoms of a missing runtime DLL.

Official references: [BrainGlobe installation](https://brainglobe.info/documentation/index.html),
[Atlas API v3 release](https://brainglobe.info/blog/brainglobe-atlasapi-v3-release.html), and
[Atlas API on PyPI](https://pypi.org/project/brainglobe-atlasapi/).
