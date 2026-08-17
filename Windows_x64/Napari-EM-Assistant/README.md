# napari EM Assistant for Windows x64

This folder creates an isolated `napari-em-assistant` Conda environment and a
**Napari EM Assistant** Desktop shortcut on 64-bit Windows 10 or 11.

It installs version 0.2.3 with two napari widgets: CLAHE local-contrast
enhancement and 2D/3D image cropping/tiling.

## Install

1. Install Anaconda or Miniconda.
2. Keep the BAT and YAML files together.
3. Double-click **Install Napari EM Assistant.bat**.
4. Wait for the package, manifest, widget, and CLAHE checks to pass.
5. Open **Napari EM Assistant** from the Desktop.

Rerunning the BAT restores the recorded versions.

## Use

Load a 2D grayscale EM image or 3D TIFF stack, then open **Plugins → napari EM
Assistant → CLAHE** or **Crop Image**. For CLAHE, begin with block size `127`,
256 histogram bins, and maximum slope `3.0`.

The fast OpenCV backend approximates ImageJ/Fiji CLAHE. Use the ImageJ
reference backend when Fiji-style behavior is the priority. Always validate
intensity and dtype behavior on representative data before quantitative use.

## Compatibility record

- Windows 10/11 x64
- Python 3.11.13
- napari 0.6.6
- napari-em-assistant 0.2.3
- NumPy 2.2.6
- OpenCV headless 4.12.0.88
- PyQt5 5.15.11

The default is CPU-only. The experimental CuPy backend is not installed
because the appropriate build depends on the machine's NVIDIA/CUDA stack. The
plugin will still provide its CPU paths.

If the shortcut does not open napari, inspect
`%TEMP%\Napari-EM-Assistant.log` or rerun the installer from Anaconda Prompt.

Upstream links: [napari hub](https://napari-hub.org/plugins/napari-em-assistant.html),
[PyPI](https://pypi.org/project/napari-em-assistant/), and
[source](https://github.com/wulinteousa2-hash/napari-em-assistant).

The upstream plugin is MIT licensed. Dependencies retain their own licences.
