# napari-N2V for macOS

This folder provides a reproducible Conda environment and a one-click macOS
installer for Noise2Void denoising through napari on an Apple Silicon Mac. It
is based on the inspected `napari-n2v` environment.

The installer creates **Napari N2V.app** on the Desktop and applies napari's
bundled application icon.

## Included files

| File | Purpose |
| --- | --- |
| `napari-n2v-macos.yaml` | Creates the `napari-n2v` Conda environment |
| `Install Napari N2V.command` | Installs N2V and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation

## Recommended: one-click installation

1. Keep `napari-n2v-macos.yaml` and `Install Napari N2V.command` in the same
   folder.
2. Double-click **Install Napari N2V.command**.
3. If macOS blocks it, right-click the file, choose **Open**, and confirm.
4. Wait until the package and TensorFlow checks finish.
5. Open **Napari N2V.app** from the Desktop.

If the environment already exists, the installer updates it. If an older
Desktop launcher exists, it is moved to the Trash as a backup.

## Manual installation

```bash
conda env create --file napari-n2v-macos.yaml
conda activate napari-n2v
napari
```

To update an existing environment:

```bash
conda env update \
  --name napari-n2v \
  --file napari-n2v-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari-n2v
python -m pip check
python -c "import tensorflow as tf; import importlib.metadata as m; print('napari-N2V:', m.version('napari-n2v')); print('TensorFlow:', tf.__version__); print('GPU:', tf.config.list_physical_devices('GPU'))"
```

## Open the N2V plugin

After napari starts:

1. Load the noisy microscopy image.
2. Open the **Plugins** menu.
3. Select **napari-n2v** and open the training widget.
4. Configure training patches and validation data.
5. Train the model using representative images.
6. Open the prediction widget and apply the saved model.

Noise2Void learns from the noisy image itself, but it still requires
representative data and careful visual validation. Preserve the original
images and do not use denoised images as replacements for raw scientific data.

## Main pinned versions

- Python 3.9.23
- napari-N2V 0.1.1
- N2V 0.3.3
- CSBDeep 0.7.4
- napari 0.5.6
- TensorFlow macOS 2.15.0
- TensorFlow Metal 1.1.0
- NumPy 1.26.4
- SciPy 1.13.1
- PyQt5 5.15.11

Python and TensorFlow are deliberately kept at these older compatible
versions. Do not independently upgrade TensorFlow, Keras, NumPy, or napari in
this environment.

## grpcio compatibility correction

The inspected environment contained `grpcio 1.80.0`, which caused:

```text
grpcio 1.80.0 is not supported on this platform
```

The supplied YAML installs the exact `grpcio 1.59.3` Python 3.9 universal2
macOS wheel. Its compiled extension contains both ARM64 and Intel code and is
compatible with TensorFlow 2.15.

This upstream wheel has an internal metadata error: its `WHEEL` file says
`x86_64` even though the actual binary is universal2. Consequently,
`pip check` prints a false platform warning. The installer ignores only that
exact warning, continues to fail on any other dependency error, and directly
tests the grpcio ARM64 and TensorFlow imports before creating the launcher.

## Troubleshooting

### The installer will not open

Right-click **Install Napari N2V.command**, choose **Open**, and confirm. If
the executable permission was removed:

```bash
chmod +x "Install Napari N2V.command"
```

### The launcher opens but napari does not appear

Read the launch log:

```bash
open -a TextEdit /tmp/napari-n2v.log
```

Launch it manually:

```bash
TF_CPP_MIN_LOG_LEVEL=1 \
  /opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari-n2v \
  napari
```

### Missing `six` METADATA file

An older or interrupted installation may report:

```text
No such file or directory: six-1.17.0.dist-info/METADATA
```

Run the updated one-click installer again. It detects this specific damaged
package record, reinstalls `six 1.17.0`, and then continues the environment
update automatically.

### TensorFlow reports no GPU

The inspected environment loads TensorFlow successfully but currently reports
no GPU device. Training and prediction will therefore use the CPU and can be
slow. Start with small crops and modest patch counts while validating the
workflow.

### Training runs out of memory

Reduce the patch size, batch size, number of patches, or image crop size.
Close other memory-intensive applications before training.

## Related projects

- [napari-N2V](https://github.com/juglab/napari-n2v)
- [Noise2Void](https://github.com/juglab/n2v)
- [napari](https://github.com/napari/napari)

## Licence

Review the licences of napari-N2V, Noise2Void, CSBDeep, TensorFlow, and napari
before redistributing software or trained models.
