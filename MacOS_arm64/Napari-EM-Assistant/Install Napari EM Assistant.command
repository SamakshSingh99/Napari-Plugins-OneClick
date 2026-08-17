#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
ENV_FILE="$SCRIPT_DIR/napari-em-assistant-macos.yaml"
ENV_NAME="napari-em-assistant"
DESKTOP_APP="$HOME/Desktop/Napari EM Assistant.app"

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

if ! /usr/bin/grep -q -- "- napari-em-assistant==0.2.3" "$ENV_FILE" || \
   ! /usr/bin/grep -q -- "- opencv-python-headless==4.12.0.88" "$ENV_FILE"; then
    echo "This installer is paired with an incompatible environment file."
    echo "Keep the current installer and YAML together."
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
    "import importlib.metadata as m, cv2, numpy as np; from napari_em_assistant.tasks.enhance_local_contrast_clahe.opencv_clahe import apply_opencv_clahe; from napari_em_assistant.tasks.enhance_local_contrast_clahe.widget import EnhanceLocalContrastCLAHEWidget; from napari_em_assistant.tasks.crop_image.widget import CropImageWidget; image=np.arange(16384,dtype=np.uint16).reshape(128,128); result=apply_opencv_clahe(image); assert result.shape==image.shape and result.dtype==image.dtype; eps=[e for e in m.entry_points(group='napari.manifest') if e.name=='napari-em-assistant']; assert eps; print('napari-em-assistant:',m.version('napari-em-assistant')); print('napari:',m.version('napari')); print('OpenCV:',cv2.__version__); print('Manifest, widgets, and CLAHE test: OK')"

echo "Creating the Desktop application..."
if [[ -e "$DESKTOP_APP" ]]; then
    BACKUP_APP="$HOME/.Trash/Napari EM Assistant backup $(date +%Y%m%d-%H%M%S).app"
    mv "$DESKTOP_APP" "$BACKUP_APP"
    echo "The previous Desktop launcher was moved to the Trash as a backup."
fi

LAUNCH_COMMAND="nohup '$CONDA_EXE' run --no-capture-output -n '$ENV_NAME' napari > /tmp/napari-em-assistant.log 2>&1 &"
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
echo "Open ‘Napari EM Assistant’ from your Desktop."
echo "In napari, open Plugins and select CLAHE or Crop Image."
echo "If macOS blocks the first launch, right-click it and choose Open."
echo "Launch log: /tmp/napari-em-assistant.log"
echo
read "?Press Return to close this window..."

trap - EXIT
exit 0
