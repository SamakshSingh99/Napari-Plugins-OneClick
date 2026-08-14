# Windows one-click installer

This folder creates a dedicated 64-bit Windows Conda environment and a Desktop
shortcut for this napari plugin.

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

## TensorFlow runtime repair

This installer pins `tensorflow==2.15.1`, the matching native Windows
`tensorflow-intel==2.15.1` runtime, Keras 2.15.0, and `ml-dtypes==0.3.1`.
Before importing Noise2Void, it verifies that `tensorflow.keras` is available.
If the runtime wheel is incomplete, the installer force-reinstalls only the
three TensorFlow/Keras wheels and repeats the check automatically.
