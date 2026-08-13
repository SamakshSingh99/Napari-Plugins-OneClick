@echo off
setlocal EnableExtensions
title One-click BrainGlobe v3 installer
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

set "ENV_FILE=%~dp0brainglobe-v3-windows.yaml"
set "ENV_NAME=brainglobe-v3"
if not exist "%ENV_FILE%" (
  echo Missing file: %ENV_FILE%
  echo Keep the BAT and YAML files together.
  goto :failed
)

findstr /c:"- brainglobe==3.0.0" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible BrainGlobe YAML file.
  echo Download the latest package and keep its BAT and YAML together.
  goto :failed
)
findstr /c:"- brainglobe-atlasapi==3.0.1" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible BrainGlobe YAML file.
  echo Download the latest package and keep its BAT and YAML together.
  goto :failed
)
findstr /l /c:"- brainreg[napari]==1.0.15" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible BrainGlobe YAML file.
  echo Download the latest package and keep its BAT and YAML together.
  goto :failed
)
findstr /l /c:"- cellfinder[napari]==1.10.1" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible BrainGlobe YAML file.
  echo Download the latest package and keep its BAT and YAML together.
  goto :failed
)
findstr /c:"- brainrender-napari==0.2.0" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible BrainGlobe YAML file.
  echo Download the latest package and keep its BAT and YAML together.
  goto :failed
)
findstr /c:"- brainglobe-napari-io==0.5.0" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible BrainGlobe YAML file.
  echo Download the latest package and keep its BAT and YAML together.
  goto :failed
)

echo Setting up Conda environment: %ENV_NAME%
"%CONDA_EXE%" env list | findstr /r /c:"^%ENV_NAME%[ ]" >nul
if not errorlevel 1 (
  echo The environment already exists; restoring the recorded versions...
  "%CONDA_EXE%" env update --name "%ENV_NAME%" --file "%ENV_FILE%" --prune
) else (
  "%CONDA_EXE%" env create --file "%ENV_FILE%"
)
if errorlevel 1 goto :failed

echo Checking installed packages...
"%CONDA_EXE%" run -n "%ENV_NAME%" python -m pip check
if errorlevel 1 goto :failed
"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import importlib.metadata as m; from brainglobe_atlasapi import BrainGlobeAtlas, show_atlases; expected={'brainglobe':'3.0.0','brainglobe-atlasapi':'3.0.1','brainglobe-heatmap':'0.6.0','brainglobe-napari-io':'0.5.0','brainglobe-segmentation':'1.3.3','brainglobe-space':'1.0.3','brainglobe-utils':'0.11.2','brainreg':'1.0.15','brainrender-napari':'0.2.0','brainrender':'2.2.1','cellfinder':'1.10.1'}; assert all(m.version(k)==v for k,v in expected.items()), {k:m.version(k) for k in expected}; print(*[f'{k}: {v}' for k,v in expected.items()],sep='\n'); print('napari:',m.version('napari')); print('Complete BrainGlobe v3 suite: OK')"
if errorlevel 1 goto :failed

set "LAUNCHER_DIR=%LOCALAPPDATA%\NapariPluginLaunchers"
if not exist "%LAUNCHER_DIR%" mkdir "%LAUNCHER_DIR%"
set "LAUNCHER_FILE=%LAUNCHER_DIR%\BrainGlobe-v3.cmd"
set "LOG_FILE=%TEMP%\BrainGlobe-v3.log"
>"%LAUNCHER_FILE%" echo @echo off
>>"%LAUNCHER_FILE%" echo "%CONDA_EXE%" run --no-capture-output -n "%ENV_NAME%" napari ^> "%LOG_FILE%" 2^>^&1

set "SHORTCUT_FILE=%USERPROFILE%\Desktop\BrainGlobe v3.lnk"
set "ENV_PREFIX="
for /f "delims=" %%P in ('"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import sys; print(sys.prefix)"') do set "ENV_PREFIX=%%P"
set "ICON_PATH=%ENV_PREFIX%\Scripts\napari.exe"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:SHORTCUT_FILE); $s.TargetPath=$env:LAUNCHER_FILE; $s.WorkingDirectory=Split-Path $env:LAUNCHER_FILE; if(Test-Path $env:ICON_PATH){$s.IconLocation=$env:ICON_PATH+',0'}; $s.WindowStyle=7; $s.Save()"
if errorlevel 1 goto :failed

echo.
echo Installation complete.
echo Desktop shortcut: BrainGlobe v3
echo BrainGlobe tools are available from napari's Plugins menu.
echo Atlas components are downloaded or streamed when first accessed.
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
