# napari FLIM Phasor Plotter — Windows x64

This folder installs `napari-flim-phasor-plotter` 0.2.3 in an independent
Conda environment and creates a **Napari FLIM Phasor Plotter** Desktop shortcut.

## Install

1. Use 64-bit Windows 10 or 11 and install Anaconda or Miniconda.
2. Keep the `.bat` and `.yaml` files together.
3. Double-click **Install Napari FLIM Phasor Plotter.bat**.
4. Wait for the package and plugin-manifest checks to pass.
5. Launch napari with the new Desktop shortcut, then select the FLIM phasor
   plotter from the **Plugins** menu.

The plugin reads raw TCSPC FLIM data including `.ptu`, `.sdt`, `.tif`, and
`.zarr`. An ordinary intensity-only TIFF cannot be used to calculate lifetime
phasors because it does not contain the decay-time bins. Verify instrument
calibration, laser frequency/harmonic, time units, and output selections before
quantitative analysis.

This setup pins Python 3.11.13, napari 0.5.6, the plugin at 0.2.3,
`napari-clusters-plotter` at 0.8.1, NumPy at its declared maximum of 1.23.5,
Dask at 2023.12.1, and HDBSCAN at 0.8.36. Rerunning the installer repairs the environment to these
recorded versions. It also pins `ptufile` and `sdtfile` at 2024.5.24 to retain
Python 3.11 compatibility and avoid later reader API changes.

Upstream links: [napari hub](https://napari-hub.org/plugins/napari-flim-phasor-plotter.html),
[documentation](https://napari-flim-phasor-plotter.readthedocs.io/), and
[PyPI](https://pypi.org/project/napari-flim-phasor-plotter/).
