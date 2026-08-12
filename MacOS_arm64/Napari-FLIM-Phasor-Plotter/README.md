# napari FLIM Phasor Plotter — Apple Silicon macOS

This folder installs `napari-flim-phasor-plotter` 0.2.3 in its own reproducible
Conda environment and creates **Napari FLIM Phasor Plotter.app** on the Desktop.

## Install

1. Install Anaconda or Miniconda if Conda is not already available.
2. Keep the `.command` and `.yaml` files together in this folder.
3. Double-click **Install Napari FLIM Phasor Plotter.command**.
4. If macOS blocks it, right-click the file, choose **Open**, and confirm.
5. After the checks pass, open the new Desktop application.

Rerunning the installer updates or repairs the environment using the versions
recorded in the YAML. An existing Desktop app is moved to the Trash as a backup
before it is replaced.

## Use

1. Open napari with the Desktop application.
2. Load a raw TCSPC FLIM file with **File → Open**. The plugin advertises readers
   for `.ptu`, `.sdt`, `.tif`, and `.zarr` data.
3. Open the FLIM phasor plotter from the **Plugins** menu.
4. Select the FLIM layer, calculate the phasors, and use the linked plot to
   inspect or select lifetime populations.

A normal intensity-only TIFF does not contain the per-pixel decay histogram
needed for lifetime phasor calculation. Use raw/exported TCSPC data with the
time-bin dimension preserved. Validate calibration, harmonic/frequency, time
units, and selections before treating the output as quantitative.

## Compatibility record

- Apple Silicon (`arm64`) macOS
- Python 3.11.13
- napari 0.5.6
- `napari-flim-phasor-plotter` 0.2.3
- `napari-clusters-plotter` 0.8.1
- NumPy 1.23.5 (the plotter's declared maximum)
- Dask 2023.12.1 (compatible with NumPy 1.23.5)
- HDBSCAN 0.8.36 (the plugin requires a version below 0.8.38)
- `ptufile` and `sdtfile` 2024.5.24

Python 3.11 is intentional: HDBSCAN 0.8.36 publishes a universal macOS wheel
for this Python version, avoiding a local C/C++ compilation on Apple Silicon.
The scientific stack is aligned with the plotter's NumPy ceiling. The FLIM
reader versions provide Python 3.11/Apple Silicon wheels and avoid later
breaking reader changes.

The plugin is still described upstream as an early-stage project, so test it
with representative data before using it in a production analysis pipeline.

Upstream links: [napari hub](https://napari-hub.org/plugins/napari-flim-phasor-plotter.html),
[documentation](https://napari-flim-phasor-plotter.readthedocs.io/), and
[PyPI](https://pypi.org/project/napari-flim-phasor-plotter/).
