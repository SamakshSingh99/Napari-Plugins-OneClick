# Windows one-click installer

This folder creates a dedicated 64-bit Windows Conda environment and a Desktop
shortcut for this napari plugin.

This corrected release uses the environment name `empanada-win310`. The new
name prevents failed older `empanada` and `empanada-win39` environments from being
reused accidentally.

Installer revision 5 uses indentation-insensitive YAML safety checks so Windows
line-ending or Git checkout transformations do not cause a false "old YAML"
message.

## Requirements

- Windows 10 or 11 x64
- Anaconda or Miniconda
- Internet access during installation and first model download

## Installation

Keep the `.bat` and `*-windows.yaml` files together, then double-click the
installer. If Windows SmartScreen appears, inspect the publisher/source and use
**More info → Run anyway** only when the files came from this repository.

The installer creates or updates the environment, runs `pip check`, verifies
that napari imports, creates a small launcher under
`%LOCALAPPDATA%\NapariPluginLaunchers`, and places a shortcut on the Desktop.

Rerunning it restores the versions recorded in the YAML. It does not silently
upgrade to untested upstream releases.

## Hardware acceleration

The default environment works without an NVIDIA GPU. CUDA is not installed
automatically because its correct version depends on the computer's driver and
plugin stack. Validate the CPU installation first before adding CUDA manually.

## Troubleshooting

- Run the installer from Anaconda Prompt if double-clicking closes too quickly.
- Read the launch log shown at the end of installation; it is stored in `%TEMP%`.
- If the environment is incomplete, remove only its exact named environment
  with `conda env remove --name ENVIRONMENT_NAME`, then rerun the installer.
- Do not install unrelated plugins into the same environment.

These Windows files are structurally validated, but each environment still
needs a clean installation test on Windows x64 before being labelled verified.

## StringZilla compiler error

This environment uses Python 3.10, which is required by `empanada-napari`
1.2.4, and pins `albumentations==1.4.18` with
`albucore==0.0.17`. This matched pair predates the StringZilla dependency, so
Microsoft Visual C++ Build Tools are not required. If an earlier installation
failed while building StringZilla, leave or remove the old `empanada`
environment and run this updated installer. It creates the separate
`empanada-win310` environment.

## PyTorch wheel error

The Windows environment uses the official CPU-only PyTorch 2.2.2 and
torchvision 0.17.2 wheels. Both support Python 3.10. The YAML fetches them
directly from PyTorch's wheel index so a stale package mirror cannot restrict
the resolver to very old Windows builds. Earlier 2.10/0.25 pins did not have
compatible wheels for the previously selected environment and must not be used
with this installer.
