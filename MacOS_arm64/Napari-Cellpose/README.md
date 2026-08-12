# Cellpose for napari on macOS

This folder provides a reproducible Conda environment and a one-click installer
for `cellpose-napari` on an Apple Silicon Mac. Cellpose segments cells, nuclei,
and other approximately cell-like objects in 2D images, stacks, and time series.

The installer creates **Napari Cellpose.app** on the Desktop, applies napari's
icon, opens the Cellpose widget automatically, and enables PyTorch's CPU
fallback for operations that Apple Metal does not support.

## Included files

| File | Purpose |
| --- | --- |
| `napari-cellpose-macos.yaml` | Creates the dedicated Conda environment |
| `Install Napari Cellpose.command` | Installs, verifies, and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation
- Internet connection when each pretrained model is used for the first time
- At least 8 GB RAM; 16 GB or more is preferable for large images and 3D stacks

## Recommended: one-click installation

1. Keep the YAML and `.command` files in the same folder.
2. Double-click **Install Napari Cellpose.command**.
3. If macOS blocks it, right-click the installer, select **Open**, and confirm.
4. Wait for all dependency and plugin checks to finish.
5. Open **Napari Cellpose.app** from the Desktop.

If the environment already exists, the installer updates it. An older Desktop
launcher is moved to the Trash as a backup before replacement.

## Manual installation

```bash
conda env create --file napari-cellpose-macos.yaml
conda activate napari-cellpose
napari -w cellpose-napari
```

To update the pinned environment:

```bash
conda env update \
  --name napari-cellpose \
  --file napari-cellpose-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari-cellpose
python -m pip check
python -c "import torch; from cellpose import models; from cellpose_napari._dock_widget import widget_wrapper; print('Cellpose plugin: OK'); print('MPS:', torch.backends.mps.is_available())"
```

The installation check does not download a model. Model files are downloaded
automatically when you run a pretrained model for the first time and are
normally cached under `~/.cellpose/models/`.

## Basic use

1. Launch **Napari Cellpose.app**.
2. Open an image, or choose a Cellpose sample from napari's **File** menu.
3. In the Cellpose panel, select the image layer.
4. Select a model:
   - **cyto3** is a sensible first choice for whole cells.
   - **nuclei** is intended for nuclear images.
   - Use a specialist model only when it matches the specimen and modality.
5. Select the main segmentation channel and optional nuclear channel.
6. Enter the approximate object diameter in pixels.
7. Start with `cellprob threshold = 0.0` and `flow threshold = 0.4`.
8. Run segmentation and inspect the mask layer carefully.

For too few or incomplete objects, lower the cell-probability threshold in
small steps. For excessive false objects, raise it. Raising the flow threshold
accepts more masks; lowering it applies stricter shape-consistency filtering.
The diameter should describe a typical object, not the image scale bar.

## 2D, stacks, and 3D

- For an ordinary 2D image, leave **process stack as 3D** off.
- For independent slices or frames, process them in 2D and optionally use the
  stitching threshold to connect corresponding masks.
- Enable 3D processing only for a true Z-stack with meaningful Z continuity.
- Confirm the channel axis before segmenting multichannel stacks.
- Test a small crop before processing a large volume.

## Apple Silicon acceleration

PyTorch may make the Apple Metal (`MPS`) backend available. The plugin requests
GPU operation and Cellpose selects the usable device. The launcher also sets
`PYTORCH_ENABLE_MPS_FALLBACK=1`, allowing unsupported operations to run on the
CPU instead of stopping the segmentation.

MPS availability does not guarantee every operation is faster. Compare a
representative image if speed matters, and monitor memory usage for 3D data.

## Why Cellpose 3 is pinned

`cellpose-napari` 0.2.0 uses Cellpose 3 interfaces and model names, including
`CellposeModel(model_type=...)`, channel selection, `cyto3`, and the older flow
outputs. Cellpose 4 changed the model family and portions of that API. Allowing
an unrestricted Cellpose upgrade could therefore break the widget even if pip
reports a successful installation.

## Main pinned versions

- Python 3.10.19
- cellpose-napari 0.2.0
- Cellpose 3.1.1.3
- napari 0.5.6
- PyTorch 2.5.1
- torchvision 0.20.1
- NumPy 1.26.4
- numba 0.61.2
- PyQt5 5.15.11

## Important limitations

- Cellpose is a generalist model; it does not guarantee biologically correct
  boundaries or counts for every tissue and imaging modality.
- Always validate masks manually on representative images from every condition.
- Use identical settings across conditions when results will be compared.
- Dense, elongated, overlapping, low-contrast, or out-of-domain objects may
  require threshold tuning, preprocessing, or a custom model.
- Do not treat model output as ground truth without an accuracy assessment.

## Troubleshooting

### The installer will not open

Right-click **Install Napari Cellpose.command** and choose **Open**. If its
executable permission was removed:

```bash
chmod +x "Install Napari Cellpose.command"
```

### The launcher opens but napari does not appear

Read the launch log:

```bash
open -a TextEdit /tmp/napari-cellpose.log
```

Launch manually:

```bash
/opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari-cellpose \
  napari -w cellpose-napari
```

### The first segmentation appears stuck

The selected model may still be downloading. Check the launch log and wait for
the download to finish. Subsequent runs use the cached model. A restricted
institutional network may require approval for the model download.

### MPS or GPU operation fails

The launcher already enables CPU fallback. If the error persists, run napari
from Terminal and retain the complete log. CPU processing remains a valid,
though usually slower, fallback for compatible image sizes.

### Cellpose 4 was installed accidentally

Restore the reproducible versions by rerunning the `.command` installer, or:

```bash
conda env update \
  --name napari-cellpose \
  --file napari-cellpose-macos.yaml \
  --prune
```

## Related projects

- [cellpose-napari documentation](https://cellpose-napari.readthedocs.io/en/latest/)
- [cellpose-napari source](https://github.com/MouseLand/cellpose-napari)
- [cellpose-napari on PyPI](https://pypi.org/project/cellpose-napari/)
- [Cellpose documentation](https://cellpose.readthedocs.io/)
- [napari](https://github.com/napari/napari)

## Licence and citation

`cellpose-napari` is distributed under the BSD-3-Clause licence. If Cellpose is
used in research, cite the relevant Cellpose publication and state the model,
software versions, dimensional mode, diameter, and thresholds used.
