# napari PHILOW — Windows x64

This folder installs `napari-PHILOW` 0.2.0 in an independent Conda environment
and creates a **Napari PHILOW** Desktop shortcut.

PHILOW provides human-in-the-loop annotation, PyTorch training and prediction
for 3D image stacks, including mitochondria and cristae workflows.

## Install

1. Use 64-bit Windows 10 or 11 and install Anaconda or Miniconda.
2. Keep the `.bat` and `.yaml` files together.
3. Double-click **Install Napari PHILOW.bat**.
4. Wait for the package, manifest and widget checks to pass.
5. Launch napari from the new Desktop shortcut.
6. Choose **Plugins → napari-PHILOW**, then open Annotation Mode, Trainer,
   Predicter or Selector.

Rerunning the installer repairs the environment to the recorded versions.

## Data and models

- PHILOW expects separate sequentially numbered 8-bit PNG slices such as
  `000.png`, `001.png`, and `002.png`.
- Masks must correspond one-for-one and use the same filenames.
- Training produces PyTorch `.pth` weights. Models and example data are not
  bundled.
- The EfficientNet encoder may download pretrained weights on first use.

Back up images, labels and trained models. Validate the workflow on a small
copy of representative data before processing a full dataset.

## CPU and NVIDIA GPU behaviour

This reproducible setup installs the standard Windows PyTorch 2.2.2 wheel and
is CPU-compatible. It does not silently install a CUDA build because CUDA must
match the computer's NVIDIA driver. CPU training and three-axis prediction can
be very slow.

An experienced user can replace PyTorch and torchvision inside this isolated
environment with the matching CUDA 11.8 or 12.1 builds from the official
PyTorch instructions. Rerunning this one-click installer will restore the
recorded CPU-compatible versions.

## Compatibility record

- 64-bit Windows 10/11
- Python 3.10.14
- napari 0.5.6
- `napari-PHILOW` 0.2.0
- NumPy 1.26.4
- PyTorch 2.2.2 and torchvision 0.17.2
- `segmentation-models-pytorch` 0.3.3

PHILOW 0.2.0 was released in May 2024 and is labelled pre-alpha upstream. The
installer therefore uses a pinned 2024-compatible stack rather than resolving
against unrestricted current dependencies.

The Windows package set has been checked for Python 3.10/x64 availability, but
this installer still needs an end-to-end test on a clean Windows computer.
Please treat it as under testing and report the complete installer output if it
fails.

Upstream links: [GitHub](https://github.com/neurobiology-ut/PHILOW),
[PyPI](https://pypi.org/project/napari-PHILOW/), and
[napari hub](https://napari-hub.org/plugins/napari-PHILOW).
