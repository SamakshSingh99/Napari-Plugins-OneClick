# napari SIFT Registration for macOS

This folder provides a reproducible Conda environment and a one-click macOS
installer for `napari-sift-registration` on an Apple Silicon Mac. The plugin
detects SIFT keypoints, matches corresponding features, estimates an affine
transformation with RANSAC, and warps a moving image onto a fixed image.

The installer creates **Napari SIFT Registration.app** on the Desktop and
applies napari's bundled application icon.

## Included files

| File | Purpose |
| --- | --- |
| `napari-sift-registration-macos.yaml` | Creates the dedicated Conda environment |
| `Install Napari SIFT Registration.command` | Installs the plugin and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation

## Recommended: one-click installation

1. Keep the YAML and `.command` files in the same folder.
2. Double-click **Install Napari SIFT Registration.command**.
3. If macOS blocks it, right-click the installer, select **Open**, and confirm.
4. Wait for the dependency, widget, and SIFT checks to finish.
5. Open **Napari SIFT Registration.app** from the Desktop.

If the environment already exists, the installer updates it. An older Desktop
launcher is moved to the Trash as a backup before replacement.

## Manual installation

```bash
conda env create --file napari-sift-registration-macos.yaml
conda activate napari-sift-registration
napari
```

To update an existing installation:

```bash
conda env update \
  --name napari-sift-registration \
  --file napari-sift-registration-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari-sift-registration
python -m pip check
python -c "import importlib.metadata as m; from napari_sift_registration._widget import example_magic_widget; print(m.version('napari-sift-registration')); print(type(example_magic_widget()).__name__)"
```

## Use the plugin

1. Open two 2D, single-channel images in napari.
2. Open **Plugins → napari-sift-registration → Affine registration with SIFT keypoints**.
3. Select the image to transform as **Moving image layer**.
4. Select the reference image as **Fixed image layer**.
5. Start with the default SIFT and RANSAC parameters.
6. Inspect the matched keypoint layers and the generated warped image.

The plugin estimates an affine transformation, so it can correct translation,
rotation, scaling, and shear. It is not a deformable or elastic registration
tool.

## Important limitations

- Supports 2D, single-channel images only.
- Registration requires enough recognizable features in both images.
- Large contrast, scale, or biological changes can reduce correct matches.
- SIFT and RANSAC may produce an incorrect transform when very few inliers are
  found; always inspect the paired keypoints and warped output.
- Images should represent approximately the same field or overlapping region.

## Main pinned versions

- Python 3.10.19
- napari-sift-registration 0.1.2
- napari 0.6.6
- scikit-image 0.25.2
- NumPy 2.2.6
- SciPy 1.15.3
- magicgui 0.10.1
- PyQt5 5.15.11

The published plugin itself contains no platform-specific compiled extension;
SIFT and RANSAC are supplied by the pinned scikit-image stack. This
combination was tested on Apple Silicon for plugin import, widget creation,
and SIFT feature detection.

## Troubleshooting

### The installer will not open

Right-click **Install Napari SIFT Registration.command** and choose **Open**.
If its executable permission was removed:

```bash
chmod +x "Install Napari SIFT Registration.command"
```

### The launcher opens but napari does not appear

Read the launch log:

```bash
open -a TextEdit /tmp/napari-sift-registration.log
```

Launch manually:

```bash
/opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari-sift-registration \
  napari
```

### No keypoints or too few matches are found

Try images with stronger texture and visible structures. Adjust SIFT
upsampling, octaves, scales, or the descriptor matching ratio gradually. A
feature-poor, heavily blurred, or non-overlapping image pair may not be
registerable with SIFT.

### The warped result is clearly incorrect

Enable display of matched keypoints and inspect the RANSAC inliers. Tighten
the inlier residual threshold or descriptor matching ratio, and confirm that
the moving and fixed layers were selected in the intended order.

## Related projects

- [napari-sift-registration](https://github.com/jfozard/napari-sift-registration)
- [Plugin page on napari hub](https://napari-hub.org/plugins/napari-sift-registration.html)
- [scikit-image SIFT documentation](https://scikit-image.org/docs/stable/api/skimage.feature.html#skimage.feature.SIFT)
- [napari](https://github.com/napari/napari)

## Licence

`napari-sift-registration` is distributed under the BSD-3-Clause licence.
Review the licences of napari, scikit-image, and the remaining dependencies
before redistribution.
