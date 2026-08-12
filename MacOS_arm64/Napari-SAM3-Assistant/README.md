# napari SAM3 for macOS

This repository provides a reproducible Conda environment and a one-click
installer for running SAM3 through napari on an Apple Silicon Mac.

It installs the `napari-sam3-assistant` plugin and the device-agnostic SAM3
source branch needed for macOS. It also creates a **Napari SAM3.app** launcher
on the Desktop with napari's icon.

> [!IMPORTANT]
> Meta's official SAM3 setup is designed primarily for CUDA systems. This
> configuration uses a community device-agnostic branch and enables PyTorch's
> MPS-to-CPU fallback. Some operations may run on the CPU and can therefore be
> slower than on a supported NVIDIA GPU.

## Included files

| File | Purpose |
| --- | --- |
| `napari-sam3-macos.yaml` | Creates the Conda environment and installs the dependencies |
| `Install Napari SAM3.command` | One-click installer that also creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation
- SAM3 model files obtained separately

The installer first looks for Conda at `/opt/anaconda3/bin/conda`. If it is not
there, it uses the `conda` command available in the shell.

## Recommended: one-click installation

1. Download both repository files and keep them in the same folder.
2. Double-click **Install Napari SAM3.command**.
3. If macOS prevents it from opening, right-click the file and select
   **Open**, then confirm.
4. Wait for the installation check to finish.
5. Open **Napari SAM3.app** from the Desktop.

The installer will:

1. Create a Conda environment named `napari-sam3`.
2. Update that environment if it already exists.
3. Install napari, PyTorch, the SAM3 assistant plugin, and SAM3.
4. Verify the Python packages and SAM3 module.
5. Create a Desktop launcher with napari's bundled icon.
6. Enable `PYTORCH_ENABLE_MPS_FALLBACK=1` for macOS.

If an older Desktop launcher exists, the installer moves it to the Trash as a
backup before creating the replacement.

## Manual installation

Open Terminal in the folder containing the downloaded files and run:

```bash
conda env create --file napari-sam3-macos.yaml
```

Activate the environment:

```bash
conda activate napari-sam3
```

Launch napari:

```bash
napari
```

If the environment already exists, update it with:

```bash
conda env update \
  --name napari-sam3 \
  --file napari-sam3-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari-sam3
python -m pip check
python -c "import napari, numpy, scipy, torch, sam3; import sam3.sam.transformer; print('Napari SAM3 imports: OK'); print('MPS:', torch.backends.mps.is_available())"
```

Expected results include:

```text
No broken requirements found.
Napari SAM3 imports: OK
MPS: True
```

Warnings saying that CUDA autocast has been disabled are expected on a Mac and
do not necessarily indicate an installation failure.

## Open the SAM3 plugin

After napari starts:

1. Open the **Plugins** menu.
2. Select the SAM3 Assistant widget.
3. Load an image into napari.
4. Select the folder or file containing your SAM3 model weights when prompted.

Model checkpoints are not included in this repository because they are large
and may have separate access or licence requirements.

## Installed package versions

The environment currently pins:

- Python 3.11
- NumPy 1.26.0
- SciPy 1.15.3
- PyTorch 2.13.0
- torchvision 0.28.0
- napari 0.8.0
- PyQt6 6.10.2
- napari-sam3-assistant 4.4.0

NumPy and SciPy are deliberately pinned. SAM3 requires NumPy 1.26.0, while
SciPy 1.15.3 remains compatible with that exact NumPy version.

SAM3 is installed from the
[`device-agnostic` branch](https://github.com/jveitchmichaelis/sam3/tree/device-agnostic).
Do not replace it with the incomplete `sam3==0.1.0` PyPI wheel if that wheel
produces `ModuleNotFoundError: No module named 'sam3.sam'`.

## Troubleshooting

### The `.command` file will not open

Right-click **Install Napari SAM3.command**, choose **Open**, and approve it in
the macOS dialog.

If macOS removed its executable permission, run:

```bash
chmod +x "Install Napari SAM3.command"
```

### The Desktop application opens but napari does not appear

Inspect the launch log:

```bash
open -a TextEdit /tmp/napari-sam3.log
```

You can also launch it directly from Terminal:

```bash
PYTORCH_ENABLE_MPS_FALLBACK=1 \
  /opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari-sam3 \
  napari
```

### `ModuleNotFoundError: No module named 'sam3.sam'`

This usually means that an incomplete SAM3 wheel was installed. Run the
one-click installer again, or update the environment from the supplied YAML.
The YAML installs the complete device-agnostic Git source.

### NumPy or SciPy dependency conflict

Do not upgrade NumPy or SciPy independently. Restore the versions in the YAML:

```bash
conda env update \
  --name napari-sam3 \
  --file napari-sam3-macos.yaml \
  --prune
```

### Processing is slow

SAM3 is a large model. Unsupported MPS operations fall back to the CPU on
macOS, so inference can be considerably slower than on a CUDA GPU. Start with
a cropped region or a smaller image while testing.

## Related projects

- [napari](https://github.com/napari/napari)
- [napari-sam3-assistant](https://github.com/wulinteousa2-hash/napari-sam3-assistant)
- [SAM3 device-agnostic branch](https://github.com/jveitchmichaelis/sam3/tree/device-agnostic)

## Licence

The installer and environment configuration do not change the licences of
napari, SAM3, PyTorch, or the plugin. Review the licence and model terms of
each upstream project before redistributing their software or model files.
