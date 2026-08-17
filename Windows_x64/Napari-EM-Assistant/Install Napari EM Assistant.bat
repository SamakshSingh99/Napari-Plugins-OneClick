@echo off
setlocal EnableExtensions
title One-click napari EM Assistant installer
cd /d "%~dp0"

if /I not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
  echo This installer is intended for 64-bit x86 Windows.
  echo Detected architecture: %PROCESSOR_ARCHITECTURE%
  goto :failed
)

set "CONDA_EXE="
if exist "%USERPROFILE%\miniconda3\Scripts\conda.exe" set "CONDA_EXE=%USERPROFILE%\miniconda3\Scripts\conda.exe"
if not defined CONDA_EXE if exist "%USERPROFILE%\anaconda3\Scripts\conda.exe" set "CONDA_EXE=%USERPROFILE%\anaconda3\Scripts\conda.exe"
if not defined CONDA_EXE if exist "%ProgramData%\miniconda3\Scripts\conda.exe" set "CONDA_EXE=%ProgramData%\miniconda3\Scripts\conda.exe"
if not defined CONDA_EXE if exist "%ProgramData%\anaconda3\Scripts\conda.exe" set "CONDA_EXE=%ProgramData%\anaconda3\Scripts\conda.exe"
if not defined CONDA_EXE for /f "delims=" %%C in ('where conda.exe 2^>nul') do if not defined CONDA_EXE set "CONDA_EXE=%%C"
if not defined CONDA_EXE (
  echo Conda was not found. Install Anaconda or Miniconda first.
  goto :failed
)

set "ENV_FILE=%~dp0napari-em-assistant-windows.yaml"
set "ENV_NAME=napari-em-assistant"
if not exist "%ENV_FILE%" goto :missing_yaml

findstr /l /c:"napari-em-assistant==0.2.3" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible environment file.
  echo Keep the current BAT and YAML together.
  goto :failed
)

echo Setting up Conda environment: %ENV_NAME%
"%CONDA_EXE%" run -n "%ENV_NAME%" python -V >nul 2>&1
if errorlevel 1 (
  "%CONDA_EXE%" env create --file "%ENV_FILE%"
) else (
  echo The environment already exists; restoring the recorded versions...
  "%CONDA_EXE%" env update --name "%ENV_NAME%" --file "%ENV_FILE%" --prune
)
if errorlevel 1 goto :failed

echo Checking installed packages...
"%CONDA_EXE%" run -n "%ENV_NAME%" python -m pip check
if errorlevel 1 goto :failed
"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import importlib.metadata as m, cv2, numpy as np; from napari_em_assistant.tasks.enhance_local_contrast_clahe.opencv_clahe import apply_opencv_clahe; from napari_em_assistant.tasks.enhance_local_contrast_clahe.widget import EnhanceLocalContrastCLAHEWidget; from napari_em_assistant.tasks.crop_image.widget import CropImageWidget; image=np.arange(16384,dtype=np.uint16).reshape(128,128); result=apply_opencv_clahe(image); assert result.shape==image.shape and result.dtype==image.dtype; eps=[e for e in m.entry_points(group='napari.manifest') if e.name=='napari-em-assistant']; assert eps; print('napari-em-assistant:',m.version('napari-em-assistant')); print('napari:',m.version('napari')); print('OpenCV:',cv2.__version__); print('Manifest, widgets, and CLAHE test: OK')"
if errorlevel 1 goto :failed

set "LAUNCHER_DIR=%LOCALAPPDATA%\NapariPluginLaunchers"
if not exist "%LAUNCHER_DIR%" mkdir "%LAUNCHER_DIR%"
set "LAUNCHER_FILE=%LAUNCHER_DIR%\Napari-EM-Assistant.cmd"
set "LOG_FILE=%TEMP%\Napari-EM-Assistant.log"
>"%LAUNCHER_FILE%" echo @echo off
>>"%LAUNCHER_FILE%" echo "%CONDA_EXE%" run --no-capture-output -n "%ENV_NAME%" napari ^> "%LOG_FILE%" 2^>^&1

set "SHORTCUT_FILE=%USERPROFILE%\Desktop\Napari EM Assistant.lnk"
set "ENV_PREFIX="
for /f "delims=" %%P in ('"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import sys; print(sys.prefix)"') do set "ENV_PREFIX=%%P"
set "ICON_PATH=%ENV_PREFIX%\Scripts\napari.exe"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:SHORTCUT_FILE); $s.TargetPath=$env:LAUNCHER_FILE; $s.WorkingDirectory=Split-Path $env:LAUNCHER_FILE; if(Test-Path $env:ICON_PATH){$s.IconLocation=$env:ICON_PATH+',0'}; $s.WindowStyle=7; $s.Save()"
if errorlevel 1 goto :failed

echo.
echo Installation complete.
echo Desktop shortcut: Napari EM Assistant
echo In napari, open Plugins and select CLAHE or Crop Image.
echo Launch log: %LOG_FILE%
echo.
pause
exit /b 0

:failed
echo.
echo Installation stopped because of an error.
echo Copy the error shown above if you need help.
pause
exit /b 1

:missing_yaml
echo.
echo The required YAML file is missing beside this installer.
echo Expected: napari-em-assistant-windows.yaml
goto :failed
