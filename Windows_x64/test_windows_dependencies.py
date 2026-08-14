#!/usr/bin/env python3
"""Resolve each Windows one-click environment without installing it.

This is a cross-platform preflight test. It checks the Conda win-64 solve and
uses uv's Windows resolver for the pip section. It cannot launch Windows GUI
applications or prove that GPU/driver-specific functionality works.
"""

from __future__ import annotations

import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]
WINDOWS_ROOT = ROOT / "Windows_x64"
CONDA = shutil.which("conda") or "/opt/anaconda3/bin/conda"
UV = shutil.which("uv") or str(Path.home() / ".local/bin/uv")


def run(command: list[str], env: dict[str, str] | None = None) -> tuple[bool, str]:
    proc = subprocess.run(
        command,
        cwd=ROOT,
        env=env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    return proc.returncode == 0, proc.stdout


def python_version(dependencies: list[object]) -> str:
    for dep in dependencies:
        if isinstance(dep, str) and dep.startswith("python="):
            value = dep.split("=", 1)[1]
            match = re.match(r"(\d+\.\d+)", value)
            if match:
                return match.group(1)
    raise ValueError("No exact Python major.minor pin found")


def pip_requirements(dependencies: list[object]) -> list[str]:
    for dep in dependencies:
        if isinstance(dep, dict) and "pip" in dep:
            return [str(item) for item in dep["pip"]]
    return []


def tail(text: str, count: int = 24) -> str:
    return "\n".join(text.rstrip().splitlines()[-count:])


def main() -> int:
    if not Path(CONDA).is_file() or not Path(UV).is_file():
        print("Required conda or uv executable was not found.", file=sys.stderr)
        return 2

    results: list[dict[str, object]] = []
    with tempfile.TemporaryDirectory(prefix="napari-windows-test-") as tmp:
        temp_root = Path(tmp)
        conda_env = os.environ.copy()
        conda_env["CONDA_REGISTER_ENVS"] = "false"
        conda_env["CONDA_PKGS_DIRS"] = str(temp_root / "conda-pkgs")
        conda_env["UV_CACHE_DIR"] = str(temp_root / "uv-cache")
        conda_env["XDG_DATA_HOME"] = str(temp_root / "data")

        for yaml_path in sorted(WINDOWS_ROOT.glob("*/*.yaml")):
            data = yaml.safe_load(yaml_path.read_text(encoding="utf-8"))
            dependencies = data.get("dependencies", [])
            py_version = python_version(dependencies)
            requirements = pip_requirements(dependencies)
            name = str(data.get("name", yaml_path.parent.name))
            print(f"\n=== {yaml_path.parent.name} ({name}, Python {py_version}) ===", flush=True)

            conda_ok, conda_output = run(
                [
                    CONDA,
                    "env",
                    "create",
                    "--dry-run",
                    "--platform",
                    "win-64",
                    "--prefix",
                    str(temp_root / "conda-envs" / yaml_path.parent.name),
                    "--file",
                    str(yaml_path),
                ],
                conda_env,
            )
            print(f"Conda win-64 solve: {'PASS' if conda_ok else 'FAIL'}", flush=True)

            pip_ok = True
            pip_output = "No pip requirements."
            if requirements:
                req_file = temp_root / f"{yaml_path.parent.name}.in"
                req_file.write_text("\n".join(requirements) + "\n", encoding="utf-8")
                output_file = temp_root / f"{yaml_path.parent.name}.txt"
                pip_ok, pip_output = run(
                    [
                        UV,
                        "pip",
                        "compile",
                        str(req_file),
                        "--python-version",
                        py_version,
                        "--python-platform",
                        "x86_64-pc-windows-msvc",
                        "--output-file",
                        str(output_file),
                        "--no-header",
                        "--no-annotate",
                        "--no-progress",
                        "--refresh",
                    ],
                    conda_env,
                )
            print(f"pip Windows resolution: {'PASS' if pip_ok else 'FAIL'}", flush=True)

            result = {
                "plugin": yaml_path.parent.name,
                "environment": name,
                "python": py_version,
                "yaml": str(yaml_path.relative_to(ROOT)),
                "conda_win64": "pass" if conda_ok else "fail",
                "pip_windows": "pass" if pip_ok else "fail",
                "conda_error": "" if conda_ok else tail(conda_output),
                "pip_error": "" if pip_ok else tail(pip_output),
            }
            results.append(result)

    print("\n=== SUMMARY ===")
    for result in results:
        print(
            f"{result['plugin']}: conda={result['conda_win64']} "
            f"pip={result['pip_windows']}"
        )
        if result["conda_error"]:
            print(result["conda_error"])
        if result["pip_error"]:
            print(result["pip_error"])

    print("\nJSON_RESULT=" + json.dumps(results, separators=(",", ":")))
    return 0 if all(
        result["conda_win64"] == "pass" and result["pip_windows"] == "pass"
        for result in results
    ) else 1


if __name__ == "__main__":
    raise SystemExit(main())
