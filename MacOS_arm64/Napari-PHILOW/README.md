# napari PHILOW — Apple Silicon macOS

This folder installs `napari-PHILOW` 0.2.0 in an independent, reproducible
Conda environment and creates **Napari PHILOW.app** on the Desktop.

PHILOW is a human-in-the-loop workflow for annotating, training and predicting
segmentation masks from 3D image stacks. It includes dedicated workflows for
mitochondria and cristae segmentation.

## Install

1. Use an Apple Silicon Mac and install Anaconda or Miniconda.
2. Keep the `.command` and `.yaml` files together in this folder.
3. Double-click **Install Napari PHILOW.command**.
4. If macOS blocks it, right-click the file, choose **Open**, and confirm.
5. After verification succeeds, open **Napari PHILOW** from the Desktop.
6. In napari, choose **Plugins → napari-PHILOW**, then open Annotation Mode,
   Trainer, Predicter or Selector.

Rerunning the installer repairs the environment to the versions recorded in
the YAML. The previous Desktop application is moved to the Trash as a backup.

## Data and models

- Input slices must be separate 8-bit PNG files with sequential names such as
  `000.png`, `001.png`, and `002.png`.
- Keep masks aligned one-for-one with the input slices and use matching names.
- Training writes PyTorch `.pth` model weights. No trained model or example
  dataset is bundled with this installer.
- Initializing the EfficientNet encoder may require internet access to download
  pretrained weights.

Back up original images, masks and model files before beginning. Test the full
workflow on a small copy of representative data before committing a large
dataset.

## Compatibility record

- Apple Silicon (`arm64`) macOS
- Python 3.10.14
- napari 0.5.6
- `napari-PHILOW` 0.2.0
- NumPy 1.26.4
- PyTorch 2.2.2 and torchvision 0.17.2
- `segmentation-models-pytorch` 0.3.3

The environment was checked for consistent requirements and verified by
importing PHILOW's napari manifest and its main widgets. PHILOW chooses Apple
MPS automatically when available, otherwise it falls back to CPU. Some PyTorch
operations may still fall back from MPS to CPU.

PHILOW 0.2.0 was released in May 2024 and is labelled pre-alpha upstream. The
installer pins a compatible dependency generation instead of automatically
combining it with the newest scientific-Python packages.

Upstream links: [GitHub](https://github.com/neurobiology-ut/PHILOW),
[PyPI](https://pypi.org/project/napari-PHILOW/), and
[napari hub](https://napari-hub.org/plugins/napari-PHILOW).
