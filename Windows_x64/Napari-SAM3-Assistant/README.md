# Windows one-click installer

This folder creates a dedicated 64-bit Windows Conda environment and a Desktop
shortcut for this napari plugin.

## Requirements

- Windows 10 or 11 x64
- Anaconda or Miniconda
- Internet access during installation

## Installation

Keep the `.bat` and `*-windows.yaml` files together, then double-click the
installer. If Windows SmartScreen appears, inspect the publisher/source and use
**More info → Run anyway** only when the files came from this repository.

The installer creates or updates the environment, runs `pip check`, verifies
that napari imports, creates a small launcher under
`%LOCALAPPDATA%\NapariPluginLaunchers`, and places a shortcut on the Desktop.

The installer does **not** download SAM3 model weights or checkpoints. After
installation, open the plugin in napari and select the path to your existing
model files there.

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

## Complete SAM3 source workaround

The pinned device-agnostic SAM3 commit contains `sam3.sam`, but its packaging
configuration includes only `sam3` and `sam3.model` in the generated wheel.
Consequently, a normal successful pip installation can later fail with
`ModuleNotFoundError: No module named 'sam3.sam'`.

Revision 1 clones the complete source at commit
`477cd99b37f634f8aa06b83936b1de669f339d00` under
`%LOCALAPPDATA%\NapariPluginSources` and registers that checkout ahead of the
wheel. The final verification explicitly imports `sam3.sam.transformer` and
confirms that Python is loading SAM3 from the complete source tree.

Revision 2 also installs `einops==0.8.1` explicitly. SAM3's
`sam3/sam/rope.py` imports it during normal model loading, but this dependency
is missing from the pinned source commit's base package metadata. The final
verification now checks `einops` before declaring the installation complete.

Revision 3 also installs `pycocotools==2.0.10`. The pinned SAM3 source imports
it during initialization through `sam3.train.data`, although it is absent from
the base dependency metadata. The final check verifies it without building or
downloading a model.
