# napari Imaris Loader for macOS

This folder provides a reproducible Conda environment and a one-click macOS
installer for `napari-imaris-loader` on an Apple Silicon Mac. The plugin opens
Bitplane Imaris `.ims` image data in napari and loads multiresolution datasets
lazily with Dask, which avoids reading an entire large file into memory at once.

The installer creates **Napari Imaris Loader.app** on the Desktop, applies
napari's bundled icon, and enables napari's asynchronous image loading.

## Included files

| File | Purpose |
| --- | --- |
| `napari-imaris-loader-macos.yaml` | Creates the dedicated Conda environment |
| `Install Napari Imaris Loader.command` | Installs, verifies, and creates the Desktop launcher |

## Requirements

- Apple Silicon Mac
- macOS
- Anaconda or Miniconda
- Internet connection during installation
- One or more Bitplane Imaris `.ims` image files for use

## Recommended: one-click installation

1. Keep the YAML and `.command` files in the same folder.
2. Double-click **Install Napari Imaris Loader.command**.
3. If macOS blocks it, right-click the installer, select **Open**, and confirm.
4. Wait for the dependency, reader-hook, and plugin checks to finish.
5. Open **Napari Imaris Loader.app** from the Desktop.

If the environment already exists, the installer updates it. An older Desktop
launcher is moved to the Trash as a backup before replacement.

## Manual installation

```bash
conda env create --file napari-imaris-loader-macos.yaml
conda activate napari-imaris-loader
NAPARI_ASYNC=1 napari
```

To update an existing installation:

```bash
conda env update \
  --name napari-imaris-loader \
  --file napari-imaris-loader-macos.yaml \
  --prune
```

## Verify the installation

```bash
conda activate napari-imaris-loader
python -m pip check
python -c "from napari_imaris_loader.reader import napari_get_reader; assert napari_get_reader('test.ims'); print('Imaris reader: OK')"
```

This checks discovery of the reader without needing a sample `.ims` file. A
real-file test is still recommended because IMS files can vary by producer and
Imaris version.

## Use the plugin

1. Launch **Napari Imaris Loader.app**.
2. Choose **File → Open File(s)** and select an `.ims` file, or drag the file
   into the napari window.
3. If napari asks which reader to use, select **napari-imaris-loader**.
4. Use the dimension sliders for time, channel, and Z, as applicable.
5. Zooming should select suitable multiscale data while Dask reads chunks on
   demand.

The plugin may also expose its resolution-control widget under the **Plugins**
menu, depending on the dimensions present in the file.

## Important limitations

- This is an image reader, not a complete Imaris replacement. It does not load
  Imaris Surfaces, Spots, Filaments, tracks, or analysis statistics.
- The plugin and its underlying reader are pre-alpha, 2022-era projects. This
  setup therefore uses an older napari compatibility stack deliberately.
- Very large files still require enough memory for the chunks and rendered
  planes currently in view.
- Some unusual 3D or 5D IMS layouts may not display correctly. Always compare
  channel order, Z order, time points, voxel dimensions, and intensities with
  the source data before quantitative work.
- The reader opens data read-only; edits made in napari are not written back to
  the original `.ims` file by this plugin.

## Main pinned versions

- Python 3.10.19
- napari-imaris-loader 0.1.8
- imaris-ims-file-reader 0.1.8
- napari 0.4.19
- NumPy 1.26.4
- h5py 3.12.1
- Dask 2024.12.1
- Zarr 2.18.7
- PyQt5 5.15.11

The published reader packages are platform-independent Python packages. NumPy,
h5py, SciPy, scikit-image, and Qt are pinned to versions that provide Apple
Silicon-compatible wheels and remain suitable for the plugin's legacy API.

## Troubleshooting

### The installer will not open

Right-click **Install Napari Imaris Loader.command** and choose **Open**. If its
executable permission was removed:

```bash
chmod +x "Install Napari Imaris Loader.command"
```

### The launcher opens but napari does not appear

Read the launch log:

```bash
open -a TextEdit /tmp/napari-imaris-loader.log
```

Launch manually:

```bash
/opt/anaconda3/bin/conda run \
  --no-capture-output \
  --name napari-imaris-loader \
  env NAPARI_ASYNC=1 napari
```

### The `.ims` file is not recognized

Confirm the extension is `.ims`, then select the reader explicitly if napari
shows a reader-choice dialog. Verify the environment using the command above.
If the file is an older, unusual, or damaged IMS variant, test a second known
working IMS file to distinguish a file-format issue from an installation issue.

### The file opens slowly or napari uses too much memory

Wait for the first view to populate before moving through many Z or time
positions. Close unneeded layers and other large applications. The Desktop
launcher already enables asynchronous loading; manual launches should include
`NAPARI_ASYNC=1` as shown above.

### Dimensions, channels, or intensities look wrong

Do not quantify the dataset yet. Compare it with Imaris or another validated
reader and check time, channel, Z, voxel scale, dtype, and intensity range. This
can indicate an unsupported file layout rather than a display-only problem.

## Related projects

- [Plugin page on napari hub](https://napari-hub.org/plugins/napari-imaris-loader.html)
- [napari-imaris-loader source](https://github.com/CBI-PITT/napari-imaris-loader)
- [imaris-ims-file-reader on PyPI](https://pypi.org/project/imaris-ims-file-reader/)
- [napari](https://github.com/napari/napari)

## Licence

`napari-imaris-loader` and `imaris-ims-file-reader` are distributed under the
BSD-3-Clause licence. Review the licences of all dependencies before
redistribution.
