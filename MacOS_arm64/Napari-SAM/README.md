# napari-SAM for macOS

This setup installs the original Segment Anything Model (SAM1) plugin for
napari on an Apple Silicon Mac. It reproduces the verified
`napari-sam-compatible` environment and creates a **Napari SAM.app** launcher
on the Desktop with napari's icon.

This setup is separate from SAM3. The two environments and launchers can
coexist:

| Setup | Conda environment | Desktop application |
| --- | --- | --- |
| Original SAM | `napari-sam-compatible` | `Napari SAM.app` |
| SAM3 | `napari-sam3` | `Napari SAM3.app` |

## Included files

| File | Purpose |
| --- | --- |
| `napari-sam-macos.yaml` | Creates the compatible original-SAM environment |
| `Install Napari SAM.command` | Installs the environment and creates the launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation
- A SAM1 checkpoint such as `sam_vit_b_01ec64.pth`,
  `sam_vit_l_0b3195.pth`, or `sam_vit_h_4b8939.pth`

Model checkpoints are not included. Obtain them separately and follow their
licence terms.

## Recommended: one-click installation

1. Keep `napari-sam-macos.yaml` and `Install Napari SAM.command` in the same
   folder.
2. Double-click **Install Napari SAM.command**.
3. If macOS blocks it, right-click it, select **Open**, and confirm.
4. Wait for the dependency and import checks to finish.
5. Open **Napari SAM.app** from the Desktop.

If the environment already exists, the installer updates it. If an older
Desktop launcher exists, it is moved to the Trash as a backup.

## Manual installation

```bash
conda env create --file napari-sam-macos.yaml
conda activate napari-sam-compatible
napari
```

To update an existing installation:

```bash
conda env update \
  --name napari-sam-compatible \
  --file napari-sam-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari-sam-compatible
python -m pip check
python -c "import napari, numpy, scipy, torch, segment_anything; from napari_sam._widget import SamWidget; print('napari-SAM imports: OK')"
```

## Use the plugin

1. Launch napari.
2. Open the **Plugins** menu.
3. Select the napari-SAM widget.
4. Load your microscopy image.
5. Choose the appropriate SAM1 checkpoint.
6. Use positive and negative point prompts or a box prompt to guide the mask.

For an Apple Silicon Mac, start with the ViT-B checkpoint. It uses less memory
and is faster than ViT-L or ViT-H. The larger checkpoints can improve some
results but are substantially slower.

## Why these versions are pinned

The working environment uses:

- Python 3.10
- napari 0.4.19
- napari-sam 0.4.13
- NumPy 1.26.4
- SciPy 1.15.3
- PyTorch 2.13.0
- torchvision 0.28.0
- PyQt5 5.15.11
- Meta Segment Anything commit `dca509f`

`napari-sam` 0.4.13 expects napari's older `layers_change` event API. Newer
napari releases, including napari 0.8, can produce an error such as:

```text
AttributeError: viewer.events.layers_change
```

Do not upgrade napari independently in this environment.

## Troubleshooting

### The installer will not open

Right-click **Install Napari SAM.command** and choose **Open**. If its
executable permission was removed:

```bash
chmod +x "Install Napari SAM.command"
```

### The launcher opens but napari does not appear

Read the launcher log:

```bash
open -a TextEdit /tmp/napari-sam.log
```

Or launch from Terminal:

```bash
NUMBA_CACHE_DIR=/tmp/napari-sam-numba-cache \
PYTORCH_ENABLE_MPS_FALLBACK=1 \
  /opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari-sam-compatible \
  napari
```

### `viewer.events.layers_change` error

Check the napari version:

```bash
conda run --name napari-sam-compatible \
  python -c "import napari; print(napari.__version__)"
```

It should report `0.4.19`. Restore the environment from the supplied YAML if
another version is installed.

### Segmentation is slow

The verified environment currently reports that PyTorch MPS acceleration is
unavailable, so SAM may run on the CPU. ViT-B is the practical starting model
for interactive work on this system.

## Related projects

- [napari](https://github.com/napari/napari)
- [napari-sam](https://github.com/MIC-DKFZ/napari-sam)
- [Segment Anything](https://github.com/facebookresearch/segment-anything)

## Licence

Review the licences and model terms of napari, napari-SAM, Segment Anything,
PyTorch, and the checkpoint provider before redistributing software or model
files.
