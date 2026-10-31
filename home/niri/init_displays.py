"""Capture the current Niri layout once, without replacing user-owned profiles."""

import argparse
import collections
import json
import os
import shlex
import subprocess
import tempfile
from pathlib import Path


def initial_profile(outputs):
    displays = list(outputs.values())
    if not any(display.get("logical") is not None for display in displays):
        raise ValueError("no enabled displays to migrate")

    descriptions = [
        " ".join(display[key] for key in ("make", "model", "serial"))
        if all(display.get(key) for key in ("make", "model", "serial"))
        else display["name"]
        for display in displays
    ]
    counts = collections.Counter(descriptions)
    lines = ["profile initial {"]
    for display, description in zip(displays, descriptions):
        criteria = description if counts[description] == 1 else display["name"]
        output = f"  output {json.dumps(criteria, ensure_ascii=False)}"
        logical = display.get("logical")
        if logical is None:
            lines.append(f"{output} disable")
            continue

        mode = display["modes"][display["current_mode"]]
        transform = logical["transform"].lower().replace("_", "")
        if transform.startswith("flipped") and transform != "flipped":
            transform = "flipped-" + transform.removeprefix("flipped")
        lines.append(
            f"{output} enable"
            f" mode {mode['width']}x{mode['height']}@{mode['refresh_rate'] / 1000:.3f}Hz"
            f" position {logical['x']},{logical['y']}"
            f" scale {logical['scale']} transform {transform}"
            f" adaptive_sync {'on' if display.get('vrr_enabled') else 'off'}"
        )
    return "\n".join([*lines, "}", ""])


def session_environment():
    environment = os.environ.copy()
    environment.setdefault("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    if not environment.get("NIRI_SOCKET"):
        # Home Manager can be activated outside the terminal's Wayland session.
        result = subprocess.run(
            ["systemctl", "--user", "show-environment"],
            capture_output=True,
            text=True,
            timeout=5,
            check=False,
            env=environment,
        )
        if result.returncode == 0:
            for line in result.stdout.splitlines():
                if line.startswith("NIRI_SOCKET="):
                    assignment = shlex.split(line)[0]
                    environment["NIRI_SOCKET"] = assignment.split("=", 1)[1]
                    break
    return environment


def initialize(path, ensure=False):
    if os.path.lexists(path):
        return

    try:
        result = subprocess.run(
            ["niri", "msg", "--json", "outputs"],
            env=session_environment(),
            capture_output=True,
            text=True,
            timeout=5,
            check=True,
        )
        content = initial_profile(json.loads(result.stdout))
    except (
        OSError,
        subprocess.SubprocessError,
        ValueError,
        KeyError,
        TypeError,
        IndexError,
    ) as error:
        print(f"niri layout initialization: current layout unavailable ({error})")
        if not ensure:
            return
        content = (
            "# Layouts saved by wdisplays; no active layout was available to migrate.\n"
        )

    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        mode="w", dir=path.parent, delete=False
    ) as temporary:
        temporary_path = Path(temporary.name)
        try:
            temporary.write(content)
            temporary.flush()
            # Publish atomically, but never replace a file created by another process.
            os.link(temporary_path, path)
        except FileExistsError:
            pass
        finally:
            temporary_path.unlink()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", type=Path)
    parser.add_argument("--ensure", action="store_true")
    arguments = parser.parse_args()
    initialize(arguments.path, ensure=arguments.ensure)
