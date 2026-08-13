#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
ENV_FILE="$SCRIPT_DIR/brainglobe-v3-macos.yaml"
ENV_NAME="brainglobe-v3"
DESKTOP_APP="$HOME/Desktop/BrainGlobe v3.app"

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
    echo "Keep the installer and YAML file together."
    exit 1
fi

if ! /usr/bin/grep -q -- "- brainglobe==3.0.0" "$ENV_FILE" || \
   ! /usr/bin/grep -q -- "- brainglobe-atlasapi==3.0.1" "$ENV_FILE" || \
   ! /usr/bin/grep -q -- "- brainreg\[napari\]==1.0.15" "$ENV_FILE" || \
   ! /usr/bin/grep -q -- "- cellfinder\[napari\]==1.10.1" "$ENV_FILE" || \
   ! /usr/bin/grep -q -- "- brainrender-napari==0.2.0" "$ENV_FILE" || \
   ! /usr/bin/grep -q -- "- brainglobe-napari-io==0.5.0" "$ENV_FILE"; then
    echo "This installer is paired with an incompatible BrainGlobe YAML file."
    echo "Download the latest package and keep its installer and YAML together."
    exit 1
fi

echo "Setting up the $ENV_NAME Conda environment..."
if "$CONDA_EXE" env list | /usr/bin/awk '{print $1}' | /usr/bin/grep -qx "$ENV_NAME"; then
    echo "The environment already exists; restoring the recorded versions..."
    "$CONDA_EXE" env update --name "$ENV_NAME" --file "$ENV_FILE" --prune
else
    "$CONDA_EXE" env create --file "$ENV_FILE"
fi

echo "Checking the installation..."
"$CONDA_EXE" run -n "$ENV_NAME" python -m pip check
QT_QPA_PLATFORM=offscreen "$CONDA_EXE" run -n "$ENV_NAME" python -c \
    "import importlib.metadata as m; from brainglobe_atlasapi import BrainGlobeAtlas, show_atlases; expected={'brainglobe':'3.0.0','brainglobe-atlasapi':'3.0.1','brainglobe-heatmap':'0.6.0','brainglobe-napari-io':'0.5.0','brainglobe-segmentation':'1.3.3','brainglobe-space':'1.0.3','brainglobe-utils':'0.11.2','brainreg':'1.0.15','brainrender-napari':'0.2.0','brainrender':'2.2.1','cellfinder':'1.10.1'}; assert all(m.version(k)==v for k,v in expected.items()), {k:m.version(k) for k in expected}; print(*[f'{k}: {v}' for k,v in expected.items()],sep='\n'); print('napari:',m.version('napari')); print('Complete BrainGlobe v3 suite: OK')"

echo "Creating the Desktop application..."
if [[ -e "$DESKTOP_APP" ]]; then
    BACKUP_APP="$HOME/.Trash/BrainGlobe v3 backup $(date +%Y%m%d-%H%M%S).app"
    mv "$DESKTOP_APP" "$BACKUP_APP"
    echo "The previous Desktop launcher was moved to the Trash as a backup."
fi

LAUNCH_COMMAND="nohup '$CONDA_EXE' run --no-capture-output -n '$ENV_NAME' napari > /tmp/brainglobe-v3.log 2>&1 &"
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
echo "Open ‘BrainGlobe v3’ from your Desktop."
echo "BrainGlobe tools are available from napari's Plugins menu."
echo "Atlas components are downloaded or streamed when first accessed."
echo "Launch log: /tmp/brainglobe-v3.log"
echo
read "?Press Return to close this window..."

trap - EXIT
exit 0
