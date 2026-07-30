# napari-Empanada for macOS

This folder provides a reproducible Conda environment and a one-click macOS
installer for running Empanada in napari on an Apple Silicon Mac. The setup is
based on the existing verified `empanada` environment.

The installer also creates **Napari Empanada.app** on the Desktop and applies
napari's bundled application icon.

## Included files

| File | Purpose |
| --- | --- |
| `empanada-macos.yaml` | Creates the Conda environment and installs Empanada |
| `Install Napari Empanada.command` | Installs or updates the environment and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation

Empanada model configurations such as MitoNet are supplied by the plugin.
Downloading model weights may require internet access the first time a model
is used.

## Recommended: one-click installation

1. Keep `empanada-macos.yaml` and `Install Napari Empanada.command` in the same
   folder.
2. Double-click **Install Napari Empanada.command**.
3. If macOS blocks it, right-click the file, choose **Open**, and confirm.
4. Wait until the dependency check finishes.
5. Open **Napari Empanada.app** from the Desktop.

If the `empanada` environment already exists, the installer updates it. If a
Desktop launcher already exists, it is moved to the Trash as a backup.

## Manual installation

```bash
conda env create --file empanada-macos.yaml
conda activate empanada
napari
```

To update an existing installation:

```bash
conda env update \
  --name empanada \
  --file empanada-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate empanada
python -m pip check
python -c "import importlib.metadata as m; print('Empanada:', m.version('empanada-napari')); print('napari:', m.version('napari'))"
```

Expected package versions include:

```text
Empanada: 1.2.4
napari: 0.6.6
```

## Open Empanada

After napari starts:

1. Load the microscopy image.
2. Open the **Plugins** menu.
3. Select an Empanada inference widget.
4. Choose an appropriate model configuration, such as MitoNet for
   mitochondria.
5. Tune the segmentation settings on a representative image or ROI before
   enabling batch processing.

## Pinned package versions

The environment pins the main working versions:

- Python 3.11
- napari 0.6.6
- empanada-napari 1.2.4
- NumPy 2.4.6
- SciPy 1.17.1
- PyTorch 2.13.0
- torchvision 0.28.0
- PyQt5 5.15.11

Avoid independently upgrading napari, NumPy, SciPy, or PyTorch in this
environment. Update using the supplied YAML so the main versions remain
coordinated.

## macOS OpenMP compatibility

The inspected environment contains more than one OpenMP runtime through its
scientific and machine-learning dependencies. Without a compatibility setting,
macOS may abort plugin loading with:

```text
OMP: Error #15: Initializing libomp.dylib, but found libomp.dylib already initialized.
```

The Desktop launcher sets `KMP_DUPLICATE_LIB_OK=TRUE` only for the Empanada
process. This is a compatibility workaround, not a global system change.
Because Intel describes this workaround as unsupported, validate segmentation
outputs and avoid using this packaged configuration for unattended production
work without further dependency testing.

## Troubleshooting

### The installer will not open

Right-click **Install Napari Empanada.command** and choose **Open**. If its
executable permission was removed:

```bash
chmod +x "Install Napari Empanada.command"
```

### The launcher opens but napari does not appear

Read the launcher log:

```bash
open -a TextEdit /tmp/napari-empanada.log
```

Launch manually with the same compatibility settings:

```bash
KMP_DUPLICATE_LIB_OK=TRUE \
NUMBA_CACHE_DIR=/tmp/empanada-numba-cache \
PYTORCH_ENABLE_MPS_FALLBACK=1 \
  /opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name empanada \
  napari
```

### Inference is slow

The inspected PyTorch installation reports that MPS acceleration is
unavailable, so inference may use the CPU. Test with a cropped ROI, use image
downsampling where scientifically acceptable, and use the mini model during
initial tuning.

### A model will not download

Confirm that the Mac has internet access and retry. If your institution blocks
model hosting services, download the model through an approved connection and
select its local configuration or checkpoint in Empanada.

## Related projects

- [napari](https://github.com/napari/napari)
- [empanada-napari](https://github.com/volume-em/empanada-napari)

## Licence

Review the licences and model terms of napari, Empanada, PyTorch, and each
model before redistributing software, configurations, or model weights.
