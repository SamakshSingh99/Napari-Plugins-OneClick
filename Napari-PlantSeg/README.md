# PlantSeg with napari for macOS

This folder provides a reproducible Conda environment and a one-click macOS
installer for launching PlantSeg's napari interface on an Apple Silicon Mac.
It reproduces the inspected `plant-seg-dev` environment.

The Desktop application launches the same command used in Terminal:

```bash
plantseg -n
```

## Included files

| File | Purpose |
| --- | --- |
| `plantseg-macos.yaml` | Creates the `plant-seg-dev` Conda environment |
| `Install Napari PlantSeg.command` | Installs PlantSeg and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation

PlantSeg downloads model files separately when required. Those files are not
included in this repository.

## Recommended: one-click installation

1. Keep `plantseg-macos.yaml` and `Install Napari PlantSeg.command` in the
   same folder.
2. Double-click **Install Napari PlantSeg.command**.
3. If macOS blocks it, right-click the file, choose **Open**, and confirm.
4. Wait until the checks finish.
5. Open **Napari PlantSeg.app** from the Desktop.

If the environment already exists, the installer updates it. If an older
Desktop launcher exists, it is moved to the Trash as a backup.

## Manual installation

```bash
conda env create --file plantseg-macos.yaml
conda activate plant-seg-dev
plantseg -n
```

To update the existing environment:

```bash
conda env update \
  --name plant-seg-dev \
  --file plantseg-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate plant-seg-dev
python -m pip check
plantseg --version
```

The reproduced environment should report PlantSeg `2.0.0b7`.

## Main pinned versions

- Python 3.13.5
- PlantSeg 2.0.0b7
- napari 0.6.1
- PyTorch 2.7.1
- NumPy 2.2.6
- SciPy 1.16.0
- scikit-image 0.25.2
- bioimageio.core 0.8.0
- PyQt 5.15.11

The inspected PyTorch build is CPU-only and reports MPS as unavailable.
PlantSeg prediction can therefore be slower than on a supported GPU.

## Using PlantSeg

1. Open **Napari PlantSeg.app**.
2. Import a microscopy image or volume.
3. Select a PlantSeg prediction model appropriate for the specimen and image
   modality.
4. Configure preprocessing and prediction.
5. Review the probability map before running instance segmentation.
6. Tune the segmentation and postprocessing on representative data before
   running a batch.

## Troubleshooting

### The installer will not open

Right-click **Install Napari PlantSeg.command**, choose **Open**, and confirm.
If the executable permission was removed:

```bash
chmod +x "Install Napari PlantSeg.command"
```

### The launcher opens but PlantSeg does not appear

Read the launcher log:

```bash
open -a TextEdit /tmp/napari-plantseg.log
```

Launch it manually:

```bash
PYTORCH_ENABLE_MPS_FALLBACK=1 \
  /opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name plant-seg-dev \
  plantseg -n
```

### Model download fails

Check the internet connection and institutional network restrictions.
PlantSeg stores downloaded models separately from the Conda environment,
normally under the user's PlantSeg model directory.

### Creating the environment fails at the Git installation

The YAML installs a pinned PlantSeg revision from GitHub. Confirm that `git`
is available and that GitHub is reachable, then retry.

## Related projects

- [PlantSeg](https://github.com/kreshuklab/plant-seg)
- [PlantSeg documentation](https://kreshuklab.github.io/plant-seg/)
- [napari](https://github.com/napari/napari)

## Licence

Review the licences and model terms of PlantSeg, napari, PyTorch, BioImage.IO,
and any downloaded model before redistribution or production use.
