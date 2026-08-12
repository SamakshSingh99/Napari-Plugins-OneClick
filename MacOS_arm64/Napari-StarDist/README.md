# StarDist for napari on macOS

This folder provides a reproducible Conda environment and one-click installer
for `stardist-napari` on an Apple Silicon Mac. StarDist detects individual
star-convex objects and is particularly useful for separating densely packed
nuclei in fluorescence and histology images.

The setup follows napari's nuclei-segmentation workshop and also includes
scikit-image, matplotlib, and pandas for measuring and plotting nucleus area,
perimeter, and circularity.

The installer creates **Napari StarDist.app** on the Desktop, applies napari's
icon, opens the StarDist panel automatically, and verifies TensorFlow and the
measurement stack.

## Included files

| File | Purpose |
| --- | --- |
| `napari-stardist-macos.yaml` | Creates the dedicated Conda environment |
| `Install Napari StarDist.command` | Installs, verifies, and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS 12 or later
- Anaconda or Miniconda
- Internet connection during installation
- Internet connection when a pretrained model is first selected
- At least 8 GB RAM; more is recommended for 3D images

## Recommended: one-click installation

1. Keep the YAML and `.command` files in the same folder.
2. Double-click **Install Napari StarDist.command**.
3. If macOS blocks it, right-click the installer, select **Open**, and confirm.
4. Wait for the dependency, TensorFlow, plugin, and measurement checks.
5. Open **Napari StarDist.app** from the Desktop.

If the environment already exists, the installer updates it. An older Desktop
launcher is moved to the Trash as a backup before replacement.

## Manual installation

```bash
conda env create --file napari-stardist-macos.yaml
conda activate napari-stardist
napari -w stardist-napari
```

To restore or update the pinned environment:

```bash
conda env update \
  --name napari-stardist \
  --file napari-stardist-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari-stardist
python -m pip check
python -c "import tensorflow as tf; from stardist.models import StarDist2D, StarDist3D; print('StarDist: OK'); print(tf.config.list_physical_devices())"
```

The check does not download any model. Pretrained models are downloaded and
cached automatically when selected for the first time.

## Segment fluorescent nuclei

1. Launch **Napari StarDist.app** and open the nucleus image.
2. If the panel is not visible, select **Plugins → stardist-napari: StarDist**.
3. Select the image layer.
4. Set the model type to **2D** for a single image.
5. Select **Versatile (fluorescent nuclei)**.
6. Enable image normalization.
7. Start with low percentile **1.00** and high percentile **99.80**.
8. Leave postprocessing and advanced options at their defaults initially.
9. Select **Run**.

The plugin produces a polygon Shapes layer and a dense instance Labels layer.
The Labels layer is the appropriate output for object counting and measurement.

## Parameter tuning in plain language

- **Probability/score threshold:** confidence required to keep a nucleus.
  Increase it to remove doubtful detections; decrease it to recover faint ones.
- **Overlap/NMS threshold:** how much predicted objects may overlap before one
  is removed. Increase it when close nuclei are being suppressed, but inspect
  for duplicate detections.
- **Normalize image:** rescales contrast to resemble the model's training data.
  It should normally remain enabled for fluorescence images.
- **Percentile low/high:** intensities mapped near the bottom and top of the
  normalized range. The workshop's 1.00/99.80 values are a good starting point.
- **Scale:** resizes objects relative to the model's expected nucleus size.
  Adjust it when nuclei are consistently much larger or smaller than expected.
- **Tiles:** divides a large image into manageable pieces. Use tiling when the
  complete image causes memory pressure; retain enough overlap to avoid seams.

Tune one setting at a time on representative crops containing bright, faint,
isolated, crowded, edge, and artefactual nuclei. Freeze the settings before
comparing experimental conditions.

## Measuring nuclei

After segmentation, open napari's Python console from **Window → Console** and
run the following. Adjust the layer name if the plugin used a different name.

```python
import numpy as np
import pandas as pd
from skimage.measure import regionprops_table

labels = viewer.layers['StarDist labels'].data
measurements = regionprops_table(
    labels,
    properties=('label', 'area', 'perimeter', 'centroid')
)
measurements = pd.DataFrame(measurements)
measurements['circularity'] = (
    4 * np.pi * measurements['area'] /
    np.square(measurements['perimeter'])
)

print(measurements)
print('Nucleus count:', len(measurements))
print('Median area:', measurements['area'].median(), 'pixels²')
```

Circularity is `4π × area ÷ perimeter²`. Values near 1 indicate a round object;
smaller values indicate less circular outlines. Very small objects and digital
perimeter estimation can produce unstable or occasionally greater-than-one
values, so filter obvious artefacts before interpreting shape statistics.

Measurements are in pixels unless the image has correct physical pixel sizes.
For biological reporting, convert area using the image calibration rather than
the visible scale bar alone.

## 2D versus 3D

- Use a 2D model for a single plane or independent 2D frames.
- Use a 3D model for a true volumetric Z-stack with correct voxel spacing.
- Do not use the 2D perimeter formula as a 3D surface-shape measurement.
- Test a small crop or subvolume before running a large dataset.
- Verify Z spacing and XY pixel size before reporting volume or physical area.

## Apple GPU acceleration

This setup uses `tensorflow-macos` with Apple's `tensorflow-metal` plugin.
TensorFlow reports available devices during installation. A `GPU` device means
Metal was registered; the CPU remains available if a particular operation is
not supported or if a small image is faster on the CPU.

The environment uses TensorFlow 2.15 deliberately. TensorFlow 2.16 made Keras 3
the default, which introduced a compatibility boundary for older model code.

## Main pinned versions

- Python 3.10.19
- stardist-napari 2024.8.6.1
- StarDist 0.9.2
- CSBDeep 0.8.2
- TensorFlow macOS 2.15.0
- TensorFlow Metal 1.1.0
- napari 0.5.6
- NumPy 1.26.4
- scikit-image 0.25.2
- PyQt5 5.15.11

StarDist 0.9.2 provides a native macOS ARM64 wheel, avoiding local compilation
on supported Apple Silicon systems.

## Important limitations

- StarDist assumes objects can be represented reasonably well by star-convex
  polygons. Highly branched or strongly concave structures are a poor match.
- Pretrained nucleus models may not generalize to every stain, microscope,
  tissue, magnification, or disease condition.
- Overlapping predictions do not prove that overlapping biological nuclei are
  present; inspect raw data and masks together.
- Always validate accuracy on manually annotated representative images before
  using counts or measurements for statistical conclusions.

## Troubleshooting

### The installer will not open

Right-click **Install Napari StarDist.command** and choose **Open**. If its
executable permission was removed:

```bash
chmod +x "Install Napari StarDist.command"
```

### The launcher opens but napari does not appear

Read the launch log:

```bash
open -a TextEdit /tmp/napari-stardist.log
```

Launch manually:

```bash
/opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari-stardist \
  napari -w stardist-napari
```

### The plugin takes a long time to open or run initially

The selected pretrained model may be downloading. Wait for completion and
inspect the launch log. Later runs should reuse the cached model.

### TensorFlow reports no GPU

Confirm that the Mac is Apple Silicon and running macOS 12 or later. Rerun the
installer to restore the matched TensorFlow packages. StarDist can still run on
the CPU, though large images and volumes will take longer.

### TensorFlow, Keras, or NumPy errors appear after an upgrade

Do not upgrade individual packages inside this environment. Rerun the installer
or restore the pinned YAML with `conda env update ... --prune` as shown above.

## Related resources

- [Napari StarDist nuclei workshop](https://napari.org/napari-workshop-template/notebooks/segmenting_and_measuring_nuclei_stardist.html)
- [stardist-napari on napari hub](https://napari-hub.org/plugins/stardist-napari)
- [stardist-napari source](https://github.com/stardist/stardist-napari)
- [StarDist project](https://github.com/stardist/stardist)
- [Apple TensorFlow Metal plugin](https://developer.apple.com/metal/tensorflow-plugin/)

## Licence and citation

`stardist-napari` is distributed under the BSD-3-Clause licence. If used for
research, cite the relevant StarDist paper and report the model, software
versions, normalization range, thresholds, dimensional mode, and calibration.
