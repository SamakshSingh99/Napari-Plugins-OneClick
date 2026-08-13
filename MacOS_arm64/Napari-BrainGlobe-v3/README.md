# BrainGlobe with Atlas API v3 — Apple Silicon macOS

This setup installs the official complete BrainGlobe 3.0.0 tool suite with
BrainGlobe Atlas API 3.0.1. It creates an isolated `brainglobe-v3` Conda
environment and **BrainGlobe v3.app** on the Desktop.

The installer uses the official `brainglobe==3.0.0` metapackage and locks its
resolved components at reproducible versions:

- Atlas API, spatial conventions, utilities, napari I/O
- brainreg registration and BrainGlobe segmentation
- cellfinder detection and its napari plugin
- brainrender, brainrender-napari, and BrainGlobe heatmaps

NiftyReg is installed from conda-forge for brainreg on macOS.

## Install

1. Install Anaconda or Miniconda.
2. Keep the `.command` and `.yaml` files together.
3. Double-click **Install BrainGlobe v3.command**.
4. If macOS blocks it, right-click it, select **Open**, and confirm.
5. After verification succeeds, open **BrainGlobe v3.app**.

Rerunning the installer repairs the environment to the recorded versions.

## Use

Open BrainGlobe tools through napari's **Plugins** menu. Atlas API v3 stores
images as OME-Zarr and obtains atlas components from AWS S3 as they are first
accessed, so internet access is required. Large/high-resolution atlases can use
substantial memory and disk space.

Check the installation manually with:

```bash
conda activate brainglobe-v3
python -m pip check
python -c "from importlib.metadata import version; print(version('brainglobe-atlasapi'))"
napari
```

`atlas.reference` is deprecated in v3; new scripts should use
`atlas.template`. Older locally stored v2 atlases are not used by v3, but do
not delete research data unless you have confirmed it is an obsolete atlas
cache and you no longer need it.

`brainglobe-workflows` remains a separate optional analysis-pipeline package;
it is not part of the complete suite installed by `pip install brainglobe`.

Official references: [BrainGlobe installation](https://brainglobe.info/documentation/index.html),
[Atlas API v3 release](https://brainglobe.info/blog/brainglobe-atlasapi-v3-release.html), and
[Atlas API on PyPI](https://pypi.org/project/brainglobe-atlasapi/).
