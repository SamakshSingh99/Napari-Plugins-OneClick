#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
ENV_FILE="$SCRIPT_DIR/napari-flim-phasor-plotter-macos.yaml"
ENV_NAME="napari-flim-phasor"
DESKTOP_APP="$HOME/Desktop/Napari FLIM Phasor Plotter.app"

pause_on_error() {
    exit_code=$?
    if (( exit_code != 0 )); then
        echo
        echo "Installation stopped because of an error."
        echo "Copy the error shown above if you need help."
        read "?Press Return to close this window..."
    fi
    exit "$exit_code"
}
trap pause_on_error EXIT

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
    echo "This installer is tested only on Apple Silicon Macs."
    echo "Detected: $(uname -s) $(uname -m)"
    exit 1
fi

if [[ -x /opt/anaconda3/bin/conda ]]; then
    CONDA_EXE=/opt/anaconda3/bin/conda
elif [[ -x "$HOME/miniconda3/bin/conda" ]]; then
    CONDA_EXE="$HOME/miniconda3/bin/conda"
elif [[ -x "$HOME/anaconda3/bin/conda" ]]; then
    CONDA_EXE="$HOME/anaconda3/bin/conda"
elif command -v conda >/dev/null 2>&1; then
    CONDA_EXE="$(command -v conda)"
else
    echo "Conda was not found. Install Anaconda or Miniconda first."
    exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing file: $ENV_FILE"
    echo "Keep the installer and YAML file in the same folder."
    exit 1
fi

if ! /usr/bin/grep -q -- "- numpy==1.23.5" "$ENV_FILE" || \
   ! /usr/bin/grep -q -- "- dask==2023.12.1" "$ENV_FILE"; then
    echo "This installer is paired with an incompatible FLIM environment file."
    echo "The YAML must contain NumPy 1.23.5 and Dask 2023.12.1."
    echo "Download the latest package and keep its installer and YAML together."
    exit 1
fi

echo "Setting up the $ENV_NAME Conda environment..."
if "$CONDA_EXE" run -n "$ENV_NAME" python -V >/dev/null 2>&1; then
    echo "The environment already exists; restoring the recorded versions..."
    "$CONDA_EXE" env update --name "$ENV_NAME" --file "$ENV_FILE" --prune
else
    "$CONDA_EXE" env create --file "$ENV_FILE"
fi

echo "Checking the installation..."
"$CONDA_EXE" run -n "$ENV_NAME" python -m pip check
QT_QPA_PLATFORM=offscreen "$CONDA_EXE" run -n "$ENV_NAME" python -c \
    "import importlib.metadata as m; import napari_flim_phasor_plotter, hdbscan, ptufile, sdtfile; eps=[e for e in m.entry_points(group='napari.manifest') if e.name=='napari-flim-phasor-plotter']; assert eps; assert m.version('napari-flim-phasor-plotter')=='0.2.3'; print('FLIM phasor plugin:',m.version('napari-flim-phasor-plotter')); print('napari:',m.version('napari')); print('Plugin manifest and FLIM readers: OK')"

echo "Creating the Desktop application..."
if [[ -e "$DESKTOP_APP" ]]; then
    BACKUP_APP="$HOME/.Trash/Napari FLIM Phasor Plotter backup $(date +%Y%m%d-%H%M%S).app"
    mv "$DESKTOP_APP" "$BACKUP_APP"
    echo "The previous Desktop launcher was moved to the Trash as a backup."
fi

LAUNCH_COMMAND="nohup '$CONDA_EXE' run --no-capture-output -n '$ENV_NAME' napari > /tmp/napari-flim-phasor-plotter.log 2>&1 &"
/usr/bin/osacompile -o "$DESKTOP_APP" -e "do shell script \"${LAUNCH_COMMAND}\""

NAPARI_ICON="$("$CONDA_EXE" run -n "$ENV_NAME" python -c \
    "import importlib.metadata as m; print(m.distribution('napari').locate_file('napari/resources/icon.icns'))" \
    | tail -n 1)"
if [[ -f "$NAPARI_ICON" ]]; then
    cp "$NAPARI_ICON" "$DESKTOP_APP/Contents/Resources/applet.icns"
    /usr/bin/touch "$DESKTOP_APP"
fi

echo
echo "Installation complete."
echo "Open ‘Napari FLIM Phasor Plotter’ from your Desktop."
echo "In napari, open Plugins and select the FLIM phasor plotter widget."
echo "If macOS blocks the first launch, right-click it and choose Open."
echo "Launch log: /tmp/napari-flim-phasor-plotter.log"
echo
read "?Press Return to close this window..."

trap - EXIT
exit 0
