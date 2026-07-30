#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
ENV_FILE="$SCRIPT_DIR/napari-n2v-macos.yaml"
ENV_NAME="napari-n2v"
DESKTOP_APP="$HOME/Desktop/Napari N2V.app"

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
    echo "Keep this installer and napari-n2v-macos.yaml in the same folder."
    exit 1
fi

echo "Setting up the $ENV_NAME Conda environment..."
if "$CONDA_EXE" run -n "$ENV_NAME" python -V >/dev/null 2>&1; then
    if ! "$CONDA_EXE" run -n "$ENV_NAME" python -c \
        "import importlib.metadata as m; d=m.distribution('six'); assert d.read_text('METADATA')" \
        >/dev/null 2>&1; then
        echo "Repairing the existing environment's missing six package metadata..."
        "$CONDA_EXE" run -n "$ENV_NAME" python -m pip install \
            --disable-pip-version-check \
            --no-deps \
            --ignore-installed \
            six==1.17.0
    fi
    echo "The environment already exists; updating it..."
    "$CONDA_EXE" env update --name "$ENV_NAME" --file "$ENV_FILE" --prune
else
    "$CONDA_EXE" env create --file "$ENV_FILE"
fi

echo "Checking the installation..."
if PIP_CHECK_OUTPUT="$("$CONDA_EXE" run -n "$ENV_NAME" python -m pip check 2>&1)"; then
    echo "$PIP_CHECK_OUTPUT"
else
    OTHER_PIP_ERRORS="$(printf '%s\n' "$PIP_CHECK_OUTPUT" | sed \
        -e '/^grpcio 1\.59\.3 is not supported on this platform$/d' \
        -e '/^WARNING:/d' \
        -e '/^ERROR conda\.cli\.main_run:/d' \
        -e '/^[[:space:]]*$/d')"
    if [[ -n "$OTHER_PIP_ERRORS" ]]; then
        echo "$PIP_CHECK_OUTPUT"
        exit 1
    fi
    echo "Dependency check: OK"
    echo "Ignoring grpcio's incorrect x86_64 metadata tag; the universal2 binary will be tested next."
fi
TF_CPP_MIN_LOG_LEVEL=1 "$CONDA_EXE" run -n "$ENV_NAME" python -c \
    "import platform, importlib.metadata as m; import grpc; import grpc._cython.cygrpc; import tensorflow as tf; assert platform.machine() == 'arm64'; print('grpcio ARM64 runtime: OK'); print('napari-N2V:', m.version('napari-n2v')); print('napari:', m.version('napari')); print('TensorFlow:', tf.__version__); print('TensorFlow GPUs:', tf.config.list_physical_devices('GPU'))"

echo "Creating the Desktop application..."
if [[ -e "$DESKTOP_APP" ]]; then
    BACKUP_APP="$HOME/.Trash/Napari N2V backup $(date +%Y%m%d-%H%M%S).app"
    mv "$DESKTOP_APP" "$BACKUP_APP"
    echo "The previous Desktop launcher was moved to the Trash as a backup."
fi

LAUNCH_COMMAND="export TF_CPP_MIN_LOG_LEVEL=1; nohup '$CONDA_EXE' run --no-capture-output -n '$ENV_NAME' napari > /tmp/napari-n2v.log 2>&1 &"
/usr/bin/osacompile -o "$DESKTOP_APP" \
    -e "do shell script \"${LAUNCH_COMMAND}\""

NAPARI_ICON="$("$CONDA_EXE" run -n "$ENV_NAME" python -c \
    "import importlib.metadata as m; print(m.distribution('napari').locate_file('napari/resources/icon.icns'))" \
    | tail -n 1)"

if [[ -f "$NAPARI_ICON" ]]; then
    cp "$NAPARI_ICON" "$DESKTOP_APP/Contents/Resources/applet.icns"
    /usr/bin/touch "$DESKTOP_APP"
fi

echo
echo "Installation complete."
echo "Open “Napari N2V” from your Desktop."
echo "If macOS blocks the first launch, right-click it and choose Open."
echo "Launch log: /tmp/napari-n2v.log"
echo
read "?Press Return to close this window..."

trap - EXIT
exit 0
