# One-click napari plugin installers for Windows

This folder contains Windows 10/11 x64 installers corresponding to the plugins
in the repository's `MacOS_arm64` folder. Each plugin uses an independent Conda
environment and receives a Desktop shortcut.

## Requirements

- 64-bit Windows 10 or Windows 11
- Anaconda or Miniconda installed for the current user
- Internet access during installation and first model download

## Install

1. Open the folder for the required plugin.
2. Keep its `.bat` installer and `.yaml` file together.
3. Double-click **Install ... .bat**.
4. Accept Windows Defender or SmartScreen only if the files came from this
   repository and have not been modified.
5. Use the new Desktop shortcut after verification succeeds.

These installers are CPU-compatible by default. An NVIDIA CUDA setup is not
silently installed because the correct PyTorch/TensorFlow build depends on the
computer's GPU driver. See each plugin README for limitations.

| Folder | Environment | Desktop shortcut |
| --- | --- | --- |
| `Napari-Cellpose` | `napari-cellpose` | Napari Cellpose |
| `Napari-Empanada` | `empanada-win39` | Napari Empanada |
| `Napari-Nellie` | `napari_nellie` | Napari Nellie |
| `Napari-Noise2Void` | `napari-n2v` | Napari Noise2Void |
| `Napari-PlantSeg` | `plant-seg-dev` | Napari PlantSeg |
| `Napari-SAM` | `napari-sam` | Napari SAM |
| `Napari-SAM3-Assistant` | `napari-sam3-windows` | Napari SAM3 Assistant |
| `Napari-SIFT-Registration` | `napari-sift-registration` | Napari SIFT Registration |
| `Napari-StarDist` | `napari-stardist` | Napari StarDist |

## Reproducibility

The YAML files pin the main compatibility-sensitive packages. New upstream
versions are not installed automatically. Rerunning an installer restores or
updates its environment to the versions recorded in that YAML.
