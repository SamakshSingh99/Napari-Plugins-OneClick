@echo off
setlocal EnableExtensions
title One-click napari plugin installer
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

set "ENV_FILE=%~dp0plantseg-windows.yaml"
set "ENV_NAME=plant-seg-dev"
if not exist "%ENV_FILE%" goto :missing_yaml

for %%I in ("%~dp0.") do set "FOLDER_NAME=%%~nxI"
set "APP_NAME=%FOLDER_NAME:Napari-=%"
set "LAUNCH_COMMAND=napari"
if /I "%FOLDER_NAME%"=="Napari-Cellpose" set "LAUNCH_COMMAND=napari -w cellpose-napari"
if /I "%FOLDER_NAME%"=="Napari-StarDist" set "LAUNCH_COMMAND=napari -w stardist-napari"
if /I "%FOLDER_NAME%"=="Napari-PlantSeg" set "LAUNCH_COMMAND=plantseg -n"

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
"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import importlib.metadata as m, napari; print('napari:', m.version('napari')); print('Plugin environment import: OK')"
if errorlevel 1 goto :failed
if /I "%FOLDER_NAME%"=="Napari-Cellpose" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import cellpose, cellpose_napari; print('Cellpose plugin: OK')"
if /I "%FOLDER_NAME%"=="Napari-Empanada" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import empanada_napari; print('Empanada plugin: OK')"
if /I "%FOLDER_NAME%"=="Napari-Nellie" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import nellie; print('Nellie plugin: OK')"
if /I "%FOLDER_NAME%"=="Napari-Noise2Void" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import n2v, napari_n2v; print('Noise2Void plugin: OK')"
if /I "%FOLDER_NAME%"=="Napari-PlantSeg" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import plantseg; print('PlantSeg: OK')"
if /I "%FOLDER_NAME%"=="Napari-SAM" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import napari_sam, segment_anything; print('SAM plugin: OK')"
if /I "%FOLDER_NAME%"=="Napari-SAM3-Assistant" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import napari_sam3_assistant, sam3; print('SAM3 Assistant: OK')"
if /I "%FOLDER_NAME%"=="Napari-SIFT-Registration" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import napari_sift_registration; print('SIFT Registration: OK')"
if /I "%FOLDER_NAME%"=="Napari-StarDist" "%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import stardist, stardist_napari, tensorflow; print('StarDist plugin: OK')"
if errorlevel 1 goto :failed

set "LAUNCHER_DIR=%LOCALAPPDATA%\NapariPluginLaunchers"
if not exist "%LAUNCHER_DIR%" mkdir "%LAUNCHER_DIR%"
set "LAUNCHER_FILE=%LAUNCHER_DIR%\%FOLDER_NAME%.cmd"
set "LOG_FILE=%TEMP%\%FOLDER_NAME%.log"
>"%LAUNCHER_FILE%" echo @echo off
>>"%LAUNCHER_FILE%" echo "%CONDA_EXE%" run --no-capture-output -n "%ENV_NAME%" %LAUNCH_COMMAND% ^> "%LOG_FILE%" 2^>^&1

set "SHORTCUT_FILE=%USERPROFILE%\Desktop\Napari %APP_NAME%.lnk"
set "ENV_PREFIX="
for /f "delims=" %%P in ('"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import sys; print(sys.prefix)"') do set "ENV_PREFIX=%%P"
set "ICON_PATH=%ENV_PREFIX%\Scripts\napari.exe"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:SHORTCUT_FILE); $s.TargetPath=$env:LAUNCHER_FILE; $s.WorkingDirectory=Split-Path $env:LAUNCHER_FILE; if(Test-Path $env:ICON_PATH){$s.IconLocation=$env:ICON_PATH+',0'}; $s.WindowStyle=7; $s.Save()"
if errorlevel 1 goto :failed

echo.
echo Installation complete.
echo Desktop shortcut: Napari %APP_NAME%
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
echo Expected: plantseg-windows.yaml
goto :failed
