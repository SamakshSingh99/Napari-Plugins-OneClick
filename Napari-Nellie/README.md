# Nellie with napari for macOS

This folder provides a reproducible Conda environment and a one-click macOS
installer for running Nellie through napari on an Apple Silicon Mac. It is
based on the inspected `napari_nellie` environment.

The installer creates **Napari Nellie.app** on the Desktop and applies
napari's bundled application icon.

## Included files

| File | Purpose |
| --- | --- |
| `napari-nellie-macos.yaml` | Creates the `napari_nellie` Conda environment |
| `Install Napari Nellie.command` | Installs Nellie and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation

## Recommended: one-click installation

1. Keep `napari-nellie-macos.yaml` and `Install Napari Nellie.command` in the
   same folder.
2. Double-click **Install Napari Nellie.command**.
3. If macOS blocks it, right-click the file, choose **Open**, and confirm.
4. Wait until the dependency and import checks finish.
5. Open **Napari Nellie.app** from the Desktop.

If the environment already exists, the installer updates it. If an older
Desktop launcher exists, it is moved to the Trash as a backup.

## Manual installation

```bash
conda env create --file napari-nellie-macos.yaml
conda activate napari_nellie
napari
```

To update an existing installation:

```bash
conda env update \
  --name napari_nellie \
  --file napari-nellie-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari_nellie
python -m pip check
python -c "import nellie; import importlib.metadata as m; print('Nellie:', m.version('nellie')); print('napari:', m.version('napari'))"
```

Expected versions include:

```text
Nellie: 1.0.4
napari: 0.6.6
```

## Open Nellie

After napari starts:

1. Open a supported microscopy image or time series.
2. Open the **Plugins** menu.
3. Select the Nellie plugin.
4. Confirm the spatial and temporal calibration before processing.
5. Configure preprocessing and segmentation using representative frames.
6. Review the results before running motion or morphology analysis.

Keep the original microscopy files unchanged and record the parameters used
for each experiment. Validate segmentation against representative raw frames
before interpreting Nellie's measurements.

## Main pinned versions

- Python 3.10.19
- Nellie 1.0.4
- napari 0.6.6
- NumPy 2.2.6
- SciPy 1.15.3
- scikit-image 0.25.2
- pandas 2.3.3
- imagecodecs 2025.3.30
- nd2 0.11.2
- ome-types 0.6.3
- PyQt5 5.15.11

The inspected environment uses the published Nellie package and does not rely
on an editable or local source-code checkout.

## Troubleshooting

### The installer will not open

Right-click **Install Napari Nellie.command**, choose **Open**, and confirm.
If the executable permission was removed:

```bash
chmod +x "Install Napari Nellie.command"
```

### The launcher opens but napari does not appear

Read the launch log:

```bash
open -a TextEdit /tmp/napari-nellie.log
```

Launch it manually:

```bash
/opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari_nellie \
  napari
```

### Nellie does not appear in the Plugins menu

Check that napari was launched from the correct environment:

```bash
conda run --name napari_nellie \
  python -c "import importlib.metadata as m; print(m.version('nellie'))"
```

It should report `1.0.4`. Close all napari windows and launch **Napari
Nellie.app** again.

### Processing is slow or uses too much memory

Start with a cropped spatial region or a short time interval. Verify the
workflow before processing the full time series. Large 3D time series can
require substantial memory and processing time.

## Related projects

- [Nellie](https://github.com/aelefebv/nellie)
- [napari](https://github.com/napari/napari)

## Licence

Review the licences of Nellie, napari, and their scientific dependencies
before redistributing software or processed datasets.
