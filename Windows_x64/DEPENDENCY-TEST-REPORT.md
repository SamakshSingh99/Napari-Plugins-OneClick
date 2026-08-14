# Windows x64 dependency-test report

Test date: **14 August 2026**

All 12 Windows one-click environments pass both preflight stages:

1. Conda can solve the YAML against the `win-64` package index.
2. `uv pip compile` can resolve the pip section for the YAML's pinned Python
   version and the `x86_64-pc-windows-msvc` platform.

| Plugin | Python | Conda win-64 | pip Windows x64 |
| --- | ---: | :---: | :---: |
| BrainGlobe v3 | 3.12 | PASS | PASS |
| Cellpose | 3.10 | PASS | PASS |
| Empanada | 3.10 | PASS | PASS |
| FLIM Phasor Plotter | 3.11 | PASS | PASS |
| Nellie | 3.10 | PASS | PASS |
| Noise2Void | 3.9 | PASS | PASS |
| PHILOW | 3.10 | PASS | PASS |
| PlantSeg | 3.13 | PASS | PASS |
| SAM | 3.10 | PASS | PASS |
| SAM3 Assistant | 3.11 | PASS | PASS |
| SIFT Registration | 3.10 | PASS | PASS |
| StarDist | 3.10 | PASS | PASS |

The 12 launchers also pass the repository checks below:

- exactly one BAT and one YAML are present in every plugin folder;
- the BAT's explicit YAML filename exists and matches the paired file;
- the BAT environment name matches the YAML environment name;
- no launcher uses the fragile `*.yaml` CMD parsing pattern;
- every BAT uses Windows CRLF line endings;
- every installer runs `python -m pip check` after installation and stops on an
  error.

## Empanada correction

Empanada was the only genuine failure in the initial audit. The environment now
uses Python 3.10 because `empanada-napari==1.2.4` does not support Python 3.9.
It also uses the matched CPU builds `torch==2.2.2+cpu` and
`torchvision==0.17.2+cpu` from PyTorch's official CPU wheel index. This avoids
the unavailable `torch==2.10.0` pin and keeps the default installer usable on
Windows machines without CUDA.

## What this test proves—and what it does not

Passing means the current package indexes contain a compatible Windows x64
dependency set. The installers additionally perform `pip check` and plugin
imports after creating a real environment on the user's computer.

This cross-platform preflight cannot launch Windows GUI applications from
macOS. A final clean Windows 10/11 smoke test is still required to prove that
napari opens, the dock widget appears, model downloads work, and local graphics
or GPU drivers behave correctly. Package releases can also change after this
dated test, so rerun the test before publishing a new installer archive.
