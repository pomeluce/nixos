"""Apply managed preferences before Chromium opens its profile files."""

import json
import os
import sys
import tempfile
from pathlib import Path


def switch_value(args, name, default):
    for index, arg in enumerate(args):
        if arg.startswith(name + "="):
            return arg.split("=", 1)[1]
        if arg == name and index + 1 < len(args):
            return args[index + 1]
    return default


def merge(target, defaults):
    for key, value in defaults.items():
        if isinstance(value, dict):
            if not isinstance(target.get(key), dict):
                target[key] = {}
            merge(target[key], value)
        else:
            target[key] = value


def read_json(path):
    if not path.exists():
        return {}
    data = json.loads(path.read_text())
    if not isinstance(data, dict):
        raise TypeError("Expected a JSON object")
    return data


def write_json(path, data):
    path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as handle:
        temporary = Path(handle.name)
        try:
            json.dump(data, handle, ensure_ascii=False)
            handle.flush()
            os.replace(temporary, path)
        finally:
            temporary.unlink(missing_ok=True)


def configure(user_data, profile_name, defaults):
    # Additional launches forward to the running browser. Never edit its files.
    if os.path.lexists(user_data / "SingletonLock"):
        return
    state_path = user_data / "Local State"
    state = read_json(state_path)
    if profile_name is None:
        profile_name = state.get("profile", {}).get("last_used", "Default")
    if Path(profile_name).name != profile_name or profile_name in (".", ".."):
        raise ValueError("Invalid profile directory")
    preferences_path = user_data / profile_name / "Preferences"
    preferences = read_json(preferences_path)
    previous_preferences = json.dumps(preferences, sort_keys=True)
    previous_state = json.dumps(state, sort_keys=True)
    merge(preferences, defaults)
    entry = state.get("profile", {}).get("info_cache", {}).get(profile_name)
    if entry is not None:
        entry["name"] = defaults["profile"]["name"]
        entry["is_using_default_name"] = False
    if json.dumps(preferences, sort_keys=True) != previous_preferences:
        user_data.mkdir(mode=0o700, parents=True, exist_ok=True)
        write_json(preferences_path, preferences)
    if json.dumps(state, sort_keys=True) != previous_state:
        write_json(state_path, state)


def main():
    defaults = read_json(Path(sys.argv[1]))
    args = sys.argv[2:]
    if any(arg in ("--version", "--product-version", "--help") for arg in args):
        return
    config_home = os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config"))
    user_data = switch_value(
        args, "--user-data-dir", str(Path(config_home) / "chromium")
    )
    profile_name = switch_value(args, "--profile-directory", None)
    try:
        configure(Path(user_data), profile_name, defaults)
    except (OSError, ValueError, TypeError):
        sys.exit(
            "Cannot apply Chromium preferences; existing profile data was preserved."
        )


if __name__ == "__main__":
    main()
