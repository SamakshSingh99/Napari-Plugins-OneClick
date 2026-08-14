@echo off
setlocal EnableExtensions
title One-click napari FLIM phasor plotter installer
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

set "ENV_FILE=%~dp0napari-flim-phasor-plotter-windows.yaml"
set "ENV_NAME=napari-flim-phasor"
if not exist "%ENV_FILE%" (
  echo Missing file: %ENV_FILE%
  echo Keep the BAT and YAML files together.
  goto :failed
)
findstr /c:"- numpy==1.23.5" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible FLIM environment file.
  echo The YAML must contain: - numpy==1.23.5
  echo Download the latest package and keep its BAT and YAML together.
  goto :failed
)
findstr /c:"- dask==2023.12.1" "%ENV_FILE%" >nul
if errorlevel 1 (
  echo This installer is paired with an incompatible FLIM environment file.
  echo The YAML must contain Dask 2023.12.1.
  echo Download the latest package and keep its BAT and YAML together.
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
"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import importlib.metadata as m; import napari_flim_phasor_plotter, hdbscan, ptufile, sdtfile; eps=[e for e in m.entry_points(group='napari.manifest') if e.name=='napari-flim-phasor-plotter']; assert eps; assert m.version('napari-flim-phasor-plotter')=='0.2.3'; print('FLIM phasor plugin:',m.version('napari-flim-phasor-plotter')); print('napari:',m.version('napari')); print('Plugin manifest and FLIM readers: OK')"
if errorlevel 1 goto :failed

set "LAUNCHER_DIR=%LOCALAPPDATA%\NapariPluginLaunchers"
if not exist "%LAUNCHER_DIR%" mkdir "%LAUNCHER_DIR%"
set "LAUNCHER_FILE=%LAUNCHER_DIR%\Napari-FLIM-Phasor-Plotter.cmd"
set "LOG_FILE=%TEMP%\Napari-FLIM-Phasor-Plotter.log"
>"%LAUNCHER_FILE%" echo @echo off
>>"%LAUNCHER_FILE%" echo "%CONDA_EXE%" run --no-capture-output -n "%ENV_NAME%" napari ^> "%LOG_FILE%" 2^>^&1

set "SHORTCUT_FILE=%USERPROFILE%\Desktop\Napari FLIM Phasor Plotter.lnk"
set "ENV_PREFIX="
for /f "delims=" %%P in ('"%CONDA_EXE%" run -n "%ENV_NAME%" python -c "import sys; print(sys.prefix)"') do set "ENV_PREFIX=%%P"
set "ICON_PATH=%ENV_PREFIX%\Scripts\napari.exe"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:SHORTCUT_FILE); $s.TargetPath=$env:LAUNCHER_FILE; $s.WorkingDirectory=Split-Path $env:LAUNCHER_FILE; if(Test-Path $env:ICON_PATH){$s.IconLocation=$env:ICON_PATH+',0'}; $s.WindowStyle=7; $s.Save()"
if errorlevel 1 goto :failed

echo.
echo Installation complete.
echo Desktop shortcut: Napari FLIM Phasor Plotter
echo Open the FLIM phasor plotter from napari's Plugins menu.
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
