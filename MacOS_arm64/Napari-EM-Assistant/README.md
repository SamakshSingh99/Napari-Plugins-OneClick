# napari EM Assistant for Apple Silicon macOS

This folder installs `napari-em-assistant` 0.2.3 in an isolated Conda
environment and creates **Napari EM Assistant.app** on the Desktop.

The plugin currently provides two task-focused widgets:

- CLAHE local-contrast enhancement for 2D grayscale EM images and 3D stacks;
- interactive, tiled, coordinate-based, and batch TIFF cropping.

## Install

1. Install Anaconda or Miniconda.
2. Keep the `.command` and `.yaml` files together.
3. Double-click **Install Napari EM Assistant.command**.
4. If macOS blocks it, right-click the file, choose **Open**, and confirm.
5. Open **Napari EM Assistant.app** from the Desktop.

Rerunning the installer restores the pinned environment. A previous Desktop
launcher is moved to the Trash as a recoverable backup before replacement.

## Use

Open an image or TIFF stack in napari, then choose either widget from the
**Plugins** menu:

- **napari EM Assistant → CLAHE** for local contrast enhancement;
- **napari EM Assistant → Crop Image** for ROI, grid, size, coordinate, or
  batch cropping.

Start CLAHE with block size `127`, histogram bins `256`, and maximum slope
`3.0`. The OpenCV backend is fast but only approximates Fiji's CLAHE. Select
the ImageJ reference backend when Fiji-like behavior matters more than speed.

## Compatibility record

- Apple Silicon (`arm64`) macOS
- Python 3.11.13
- napari 0.6.6
- napari-em-assistant 0.2.3
- NumPy 2.2.6
- OpenCV headless 4.12.0.88
- PyQt5 5.15.11

The installer verifies the napari manifest, both widget imports, and a
synthetic `uint16` OpenCV CLAHE operation before creating the launcher.

## GPU note

This installer uses the CPU backends. The plugin's experimental CuPy backend
requires NVIDIA CUDA and is therefore not installed on Apple Silicon. CPU
fallback remains available.

## Scientific-use note

OpenCV and ImageJ CLAHE do not implement identical parameter meanings. Check
dtype and intensity behavior on representative images before quantitative use,
and keep original data unchanged. Large batch-crop jobs can create many files;
review the predicted count and destination folder first.

Upstream links: [napari hub](https://napari-hub.org/plugins/napari-em-assistant.html),
[PyPI](https://pypi.org/project/napari-em-assistant/), and
[source](https://github.com/wulinteousa2-hash/napari-em-assistant).

The upstream plugin is MIT licensed. Dependencies retain their own licences.
