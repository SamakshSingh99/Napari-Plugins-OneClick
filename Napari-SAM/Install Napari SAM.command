#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
ENV_FILE="$SCRIPT_DIR/napari-sam-macos.yaml"
ENV_NAME="napari-sam"
DESKTOP_APP="$HOME/Desktop/Napari SAM.app"

pause_on_error() {
    status=$?
    if (( status != 0 )); then
        echo
        echo "Installation stopped because of an error."
        echo "Copy the error shown above if you need help."
        read "?Press Return to close this window..."
    fi
    exit "$status"
}
trap pause_on_error EXIT

if [[ -x /opt/anaconda3/bin/conda ]]; then
    CONDA_EXE=/opt/anaconda3/bin/conda
elif command -v conda >/dev/null 2>&1; then
    CONDA_EXE="$(command -v conda)"
else
    echo "Conda was not found. Install Anaconda or Miniconda first."
    exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing file: $ENV_FILE"
    echo "Keep this installer and napari-sam-macos.yaml in the same folder."
    exit 1
fi

echo "Setting up the $ENV_NAME Conda environment..."
if "$CONDA_EXE" run -n "$ENV_NAME" python -V >/dev/null 2>&1; then
    echo "The environment already exists; updating it..."
    "$CONDA_EXE" env update --name "$ENV_NAME" --file "$ENV_FILE" --prune
else
    "$CONDA_EXE" env create --file "$ENV_FILE"
fi

echo "Checking the installation..."
"$CONDA_EXE" run -n "$ENV_NAME" python -m pip check
NUMBA_CACHE_DIR=/tmp/napari-sam-numba-cache \
    "$CONDA_EXE" run -n "$ENV_NAME" python -c \
    "import napari, numpy, scipy, torch, segment_anything; from napari_sam._widget import SamWidget; print('napari-SAM imports: OK')"

echo "Creating the Desktop application..."
if [[ -e "$DESKTOP_APP" ]]; then
    BACKUP_APP="$HOME/.Trash/Napari SAM backup $(date +%Y%m%d-%H%M%S).app"
    mv "$DESKTOP_APP" "$BACKUP_APP"
    echo "The previous Desktop launcher was moved to the Trash as a backup."
fi

LAUNCH_COMMAND="export PYTORCH_ENABLE_MPS_FALLBACK=1; export NUMBA_CACHE_DIR=/tmp/napari-sam-numba-cache; mkdir -p /tmp/napari-sam-numba-cache; nohup '$CONDA_EXE' run --no-capture-output -n '$ENV_NAME' napari > /tmp/napari-sam.log 2>&1 &"
/usr/bin/osacompile -o "$DESKTOP_APP" \
    -e "do shell script \"${LAUNCH_COMMAND}\""

NAPARI_ICON="$("$CONDA_EXE" run -n "$ENV_NAME" python -c \
    "from pathlib import Path; import napari; print(Path(napari.__file__).parent / 'resources' / 'icon.icns')" \
    | tail -n 1)"

if [[ -f "$NAPARI_ICON" ]]; then
    cp "$NAPARI_ICON" "$DESKTOP_APP/Contents/Resources/applet.icns"
    /usr/bin/touch "$DESKTOP_APP"
fi

echo
echo "Installation complete."
echo "Open “Napari SAM” from your Desktop."
echo "If macOS blocks the first launch, right-click it and choose Open."
echo "Launch log: /tmp/napari-sam.log"
echo
read "?Press Return to close this window..."

trap - EXIT
exit 0
