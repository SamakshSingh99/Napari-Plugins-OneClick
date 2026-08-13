<div align="center">

# 🔬 Napari Plugins OneClick

### Spend less time negotiating with Conda. Spend more time analysing images.

[![napari](https://img.shields.io/badge/built%20for-napari-4D77CF?style=for-the-badge)](https://napari.org/)
[![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon-000000?style=for-the-badge&logo=apple)](#-installers-currently-included)
[![Windows](https://img.shields.io/badge/Windows-10%2F11%20x64-0078D4?style=for-the-badge&logo=windows11)](#-installers-currently-included)
[![Status](https://img.shields.io/badge/status-work%20in%20progress-F59E0B?style=for-the-badge)](#-work-in-progress)

**Reproducible, isolated, one-click installers for the napari plugin ecosystem.**

[Choose a plugin](#-installers-currently-included) · [Quick start](#-quick-start) · [How it works](#-what-one-click-means-here) · [Request a plugin](https://github.com/SamakshSingh99/Napari-Plugins-OneClick/issues)

</div>

---

## 🚧 Work in progress

> [!WARNING]
> **This repository is under active development.** The installers are being
> built, revised and tested progressively; they have not yet been validated on
> every computer, operating-system release or hardware configuration. Some may
> work immediately, while others may reveal a dependency or platform issue that
> still needs to be solved.

At this stage, the repository is best viewed as a growing collection of
reproducible installation experiments.
Early testers are welcome, but please use the installers with that expectation
and [report what happens](https://github.com/SamakshSingh99/Napari-Plugins-OneClick/issues).

Current priorities are to:

- test every setup on clean macOS and Windows machines;
- record failures and hardware-specific limitations;
- improve recovery from interrupted or partial installations;
- update version combinations as the plugins evolve; and
- steadily add more of the napari plugin ecosystem.

## The familiar story

You discover a napari plugin that could transform your analysis. The README
says `pip install ...`, so you expect to be testing it in five minutes.

Then the adventure begins:

- Python versions disagree.
- NumPy wants one version; SciPy wants another.
- PyTorch, TensorFlow or Qt joins the conversation.
- A compiled dependency has no wheel for your computer.
- Fixing one plugin quietly breaks another.
- Your “quick installation” becomes an afternoon of dependency archaeology.

For experienced Python users, this is frustrating. For researchers who simply
need to analyse microscopy data, it can be a complete barrier.

**That is why I started Napari Plugins OneClick.**

The idea is simple: take the difficult environment work—version selection,
dependency isolation, platform-specific fixes, verification and launcher
creation—and package it into a setup that a scientist can run by double-clicking
a file.

> [!NOTE]
> This began as a practical solution to my own installation problems. It has
> since become a personal challenge: **keep going until every napari plugin that
> can be packaged this way has a dependable one-click installer.** Ambitious?
> Certainly. A little unreasonable? Probably. Worth attempting? Absolutely.

## ✨ What this project gives you

| Without this project | With Napari Plugins OneClick |
| --- | --- |
| Manually choose Python and package versions | Use a prepared environment specification |
| Resolve dependency conflicts yourself | Keep compatibility-sensitive versions together |
| Risk breaking an existing napari setup | Give every plugin its own isolated environment |
| Activate environments and remember commands | Launch the plugin from a Desktop icon |
| Discover failures only after napari opens | Run package and import checks during installation |
| Repeat the setup manually on another computer | Reuse the same installer and YAML pair |

This approach is especially useful for:

- 🔬 **Microscopy and bioimage-analysis researchers** who want to focus on data
- 🧑‍🎓 **Students and workshop participants** who are new to Python environments
- 🧪 **Core facilities and imaging teams** supporting several analysis stations
- 👩‍🏫 **Trainers and educators** who need a more consistent classroom setup
- 🧑‍💻 **Plugin developers and testers** who want clean, separated installations

## 🚀 Quick start

### macOS — Apple Silicon

1. Install [Anaconda](https://www.anaconda.com/download) or
   [Miniconda](https://docs.conda.io/projects/miniconda/en/latest/).
2. Download or clone this repository.
3. Open the folder for the plugin you want.
4. Keep the `.command` installer and its `.yaml` file together.
5. Double-click **Install … `.command`**.
6. If macOS blocks it, right-click the installer, choose **Open**, and confirm.
7. After the checks pass, open the new napari application from your Desktop.

### Windows — 64-bit Windows 10 or 11

1. Install [Anaconda](https://www.anaconda.com/download) or
   [Miniconda](https://docs.conda.io/projects/miniconda/en/latest/).
2. Open [`Windows_x64`](Windows_x64/README.md), then choose a plugin folder.
3. Keep the `.bat` installer and its `.yaml` file together.
4. Double-click **Install … `.bat`**.
5. Only accept a SmartScreen warning if you downloaded the unmodified files
   from this repository.
6. After verification succeeds, use the new Desktop shortcut.

> [!IMPORTANT]
> “One click” begins after Conda is installed. Internet access is required
> during setup, and some plugins download model weights separately when first
> used.

## 🧰 Installers currently included

🧪 Included and under testing · — Not currently packaged for that platform

| Plugin / tool | What it helps with | Apple Silicon macOS | Windows x64 |
| --- | --- | :---: | :---: |
| **Cellpose** | Generalist cell and nucleus segmentation | [🧪](MacOS_arm64/Napari-Cellpose/) | [🧪](Windows_x64/Napari-Cellpose/README.md) |
| **Empanada** | Deep-learning segmentation, including MitoNet | [🧪](MacOS_arm64/Napari-Empanada/)  | [🧪](Windows_x64/Napari-Empanada/README.md) |
| **PlantSeg** | Plant-cell and tissue segmentation | [🧪](MacOS_arm64/Napari-PlantSeg/)  | [🧪](Windows_x64/Napari-PlantSeg/README.md) |
| **Noise2Void** | Self-supervised image denoising | [🧪](MacOS_arm64/Napari-Noise2Void/)  | [🧪](Windows_x64/Napari-Noise2Void/README.md) |
| **Nellie** | Organelle segmentation and dynamics | [🧪](MacOS_arm64/Napari-Nellie/)  | [🧪](Windows_x64/Napari-Nellie/README.md) |
| **Original SAM**| Promptable segmentation with Segment Anything | [🧪](MacOS_arm64/Napari-SAM/)  | [🧪](Windows_x64/Napari-SAM/README.md) |
| **SAM3 Assistant** | SAM3-assisted segmentation | [🧪](MacOS_arm64/Napari-SAM3-Assistant/)  | [🧪](Windows_x64/Napari-SAM3-Assistant/README.md) |
| **SIFT Registration** | Feature-based 2D image registration | [🧪](MacOS_arm64/Napari-SIFT-Registration/)  | [🧪](Windows_x64/Napari-SIFT-Registration/README.md) |
| **StarDist** | 2D/3D star-convex object segmentation | [🧪](MacOS_arm64/Napari-StarDist/)  | [🧪](Windows_x64/Napari-StarDist/README.md) |
| **FLIM Phasor Plotter** | FLIM loading, phasor analysis and population selection | [🧪](MacOS_arm64/Napari-FLIM-Phasor-Plotter/)  | [🧪](Windows_x64/Napari-FLIM-Phasor-Plotter/README.md) |
| **BrainGlobe v3** | Neuroanatomy, registration, detection and atlas tools | [🧪](MacOS_arm64/Napari-BrainGlobe-v3/) | [🧪](Windows_x64/Napari-BrainGlobe-v3/README.md) |
| **Imaris Loader** | Lazy, multiscale loading of `.ims` files | [🧪](MacOS_arm64/Napari-Imaris-Loader/)  | — |

Each linked page documents that setup's requirements, installed environment,
launcher and known limitations. Inclusion in this table means an installer is
present—not that it has been exhaustively validated on every system.

## ⚙️ What “one click” means here

Each plugin is treated as its own small application:

```text
Double-click installer
        ↓
Find Conda and check the operating system
        ↓
Create or repair an isolated environment from YAML
        ↓
Install the currently selected dependency combination
        ↓
Run package, import and plugin checks
        ↓
Create a Desktop launcher with the napari icon
        ↓
Open napari without manually activating an environment
```

The important design choice is **one environment per plugin**. Scientific
Python packages often need different—and sometimes mutually incompatible—
versions of NumPy, SciPy, Qt, PyTorch, TensorFlow and napari. Isolation lets
those combinations coexist instead of forcing every plugin into one fragile
environment.

## 🧬 Reproducibility philosophy

These installers favour **known compatibility over automatic novelty**.

- Main compatibility-sensitive packages are recorded in YAML.
- Installers check that they are paired with the intended YAML file.
- Existing environments can be updated or repaired by rerunning the installer.
- Verification happens before a Desktop launcher is presented as ready.
- Different plugins receive different environment and launcher names.

Upstream projects continue to evolve, so no installer remains reproducible
forever without maintenance. When a plugin or dependency changes, the setup
must be reviewed, updated and tested again. That maintenance is part of this
project—not something hidden from the user.

## 🗺️ The personal challenge

The long-term goal is bold: **build a practical one-click path for as much of
the napari plugin ecosystem as possible.**

The journey includes:

- expanding macOS and Windows coverage;
- adding more plugins across segmentation, registration, denoising, tracking,
  visualization and file I/O;
- improving validation and recovery from partial installations;
- documenting hardware, model and data requirements clearly;
- revisiting installers as upstream packages release new versions; and
- learning from the researchers and developers who test them.

Not every plugin will be straightforward. Some depend on proprietary software,
special hardware, platform-specific binaries, external model licences or
services that cannot be bundled. Those constraints will be documented honestly
rather than disguised behind a “one-click” label.

## 🤝 Help the challenge grow

This project will be most useful if it reflects real problems faced by the
napari community.

- **Request a plugin:** [open an issue](https://github.com/SamakshSingh99/Napari-Plugins-OneClick/issues)
- **Report a failure:** include your operating system, processor, installer
  folder and the complete error message
- **Test an installer:** let me know whether it worked on a clean machine
- **Improve documentation:** corrections and clearer instructions are welcome
- **Contribute a setup:** submit a pull request with the installer, environment
  file, verification steps and plugin-specific README
- **Share the project:** help it reach researchers who are currently stuck at
  the installation stage

When reporting a problem, please never post passwords, access tokens, private
data paths or sensitive research data.

## ⚠️ Scope and responsibility

This is a community installation project, not an official napari distribution
and not an official distribution of the included plugins. The plugins, models
and dependencies remain the work of their respective authors and retain their
own licences and citation requirements.

Before scientific use:

- read the plugin's official documentation;
- validate outputs against suitable controls and ground truth;
- confirm model licences and citation requirements;
- test workflows on representative data; and
- do not treat successful installation as validation of a scientific method.

GPU acceleration is not silently configured on Windows because the correct
CUDA build depends on the computer, GPU and installed driver. CPU-compatible
defaults may be slower but are less likely to create an unusable setup.

## 💙 Why this matters

Powerful open-source image-analysis tools only create impact when people can
actually run them. A dependency error should not decide who gets to use modern
segmentation, denoising or registration methods.

If this repository saves someone an afternoon of environment debugging—and
lets them spend that afternoon understanding their images instead—it has done
something worthwhile.

<div align="center">

### From “dependency conflict” to “open image” — one plugin at a time.

If the idea helps you, consider starring the repository, testing an installer,
or suggesting the next plugin to tackle. ⭐

[⬆ Back to the top](#-napari-plugins-oneclick)

</div>
