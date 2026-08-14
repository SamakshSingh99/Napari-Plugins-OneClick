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

## CMD reports that the YAML was unexpected

Use the current installer package and keep each `.bat` file beside the exact
YAML supplied in its plugin folder. Current launchers use an explicit YAML and
environment name and do not parse them through a nested CMD command. This also
allows the downloaded repository folder to contain spaces or parentheses, such
as `Napari-Plugins-OneClick-main (1)`.

Do not rename only the YAML or combine files from different release archives.
If an older download prints `napari-...-windows.yaml was unexpected at this
time`, replace both the BAT and YAML with the matching files from the current
package.

| Folder | Environment | Desktop shortcut |
| --- | --- | --- |
| `Napari-Cellpose` | `napari-cellpose` | Napari Cellpose |
| `Napari-Empanada` | `empanada-win310` | Napari Empanada |
| `Napari-Nellie` | `napari_nellie` | Napari Nellie |
| `Napari-Noise2Void` | `napari-n2v` | Napari Noise2Void |
| `Napari-PlantSeg` | `plant-seg-dev` | Napari PlantSeg |
| `Napari-SAM` | `napari-sam` | Napari SAM |
| `Napari-SAM3-Assistant` | `napari-sam3-windows` | Napari SAM3 Assistant |
| `Napari-SIFT-Registration` | `napari-sift-registration` | Napari SIFT Registration |
| `Napari-StarDist` | `napari-stardist` | Napari StarDist |
| `Napari-FLIM-Phasor-Plotter` | `napari-flim-phasor` | Napari FLIM Phasor Plotter |
| `Napari-BrainGlobe-v3` | `brainglobe-v3` | BrainGlobe v3 |
| `Napari-PHILOW` | `napari-philow-win` | Napari PHILOW |

## Reproducibility

The YAML files pin the main compatibility-sensitive packages. New upstream
versions are not installed automatically. Rerunning an installer restores or
updates its environment to the versions recorded in that YAML.

## Dependency test status

All 12 environments passed the Windows x64 Conda solve and Windows pip package
resolution test on 14 August 2026. Each BAT/YAML pair also passed the static
launcher checks, including environment-name matching, explicit YAML selection,
CRLF line endings, and an installed-environment `pip check` step.

See [DEPENDENCY-TEST-REPORT.md](DEPENDENCY-TEST-REPORT.md) for the results and
test limitations. Maintainers can rerun the cross-platform preflight with:

```text
python Windows_x64/test_windows_dependencies.py
```

This requires Conda, `uv`, PyYAML, internet access, and current win-64 package
metadata. It resolves the Windows packages without installing or launching the
Windows GUI applications.
