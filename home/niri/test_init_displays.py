import contextlib
import io
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from init_displays import initial_profile, initialize, session_environment


def display(name="eDP-1", serial="1234"):
    return {
        "name": name,
        "make": "Example",
        "model": "Panel",
        "serial": serial,
        "modes": [{"width": 3200, "height": 2000, "refresh_rate": 165001}],
        "current_mode": 0,
        "logical": {"x": 0, "y": 0, "scale": 1.5, "transform": "Normal"},
        "vrr_enabled": False,
    }


class InitialProfileTests(unittest.TestCase):
    def test_preserves_mode_scale_position_rotation_and_disabled_outputs(self):
        internal = display()
        external = display("DP-1", "5678")
        external["logical"].update(x=2134, y=-100, transform="Flipped90")
        external["vrr_enabled"] = True
        disabled = display("HDMI-A-1", None)
        disabled["logical"] = None
        disabled["current_mode"] = None
        profile = initial_profile(
            {"internal": internal, "external": external, "disabled": disabled}
        )
        self.assertIn(
            'output "Example Panel 1234" enable mode 3200x2000@165.001Hz', profile
        )
        self.assertIn(
            "position 2134,-100 scale 1.5 transform flipped-90 adaptive_sync on",
            profile,
        )
        self.assertIn('output "HDMI-A-1" disable', profile)

    def test_duplicate_descriptions_use_connectors(self):
        profile = initial_profile({"one": display("DP-1"), "two": display("DP-2")})
        self.assertIn('output "DP-1" enable', profile)
        self.assertIn('output "DP-2" enable', profile)

    def test_quotes_in_display_identity_are_escaped(self):
        output = display()
        output["model"] = 'Panel "Pro"'
        self.assertIn(
            r'output "Example Panel \"Pro\" 1234"', initial_profile({"one": output})
        )

    def test_empty_or_all_disabled_layout_is_not_saved(self):
        with self.assertRaises(ValueError):
            initial_profile({})
        output = display()
        output["logical"] = None
        with self.assertRaises(ValueError):
            initial_profile({"one": output})


class InitializationTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.path = Path(self.directory.name) / "kanshi" / "config"
        self.environment = patch("init_displays.session_environment", return_value={})
        self.environment.start()
        self.addCleanup(self.environment.stop)

    def test_creates_writable_snapshot_only_once(self):
        result = subprocess.CompletedProcess(
            [], 0, stdout=json.dumps({"one": display()})
        )
        with patch("init_displays.subprocess.run", return_value=result) as command:
            initialize(self.path)
            original = self.path.read_text()
            initialize(self.path, ensure=True)
        self.assertEqual(command.call_count, 1)
        self.assertEqual(self.path.read_text(), original)
        self.assertTrue(self.path.stat().st_mode & 0o200)
        self.assertEqual(list(self.path.parent.iterdir()), [self.path])

    def test_preserves_existing_file_and_symlink(self):
        self.path.parent.mkdir()
        self.path.write_text("# user configuration\n")
        with patch("init_displays.subprocess.run") as command:
            initialize(self.path)
            self.assertEqual(self.path.read_text(), "# user configuration\n")
            self.path.unlink()
            self.path.symlink_to(self.path.parent / "missing-target")
            initialize(self.path, ensure=True)
            command.assert_not_called()
        self.assertTrue(self.path.is_symlink())

    def test_offline_activation_defers_but_service_can_create_empty_config(self):
        with (
            patch("init_displays.subprocess.run", side_effect=OSError("no session")),
            contextlib.redirect_stdout(io.StringIO()),
        ):
            initialize(self.path)
            self.assertFalse(self.path.exists())
            initialize(self.path, ensure=True)
        self.assertTrue(self.path.exists())
        self.assertNotIn("profile", self.path.read_text())

    def test_file_created_concurrently_is_not_overwritten(self):
        real_link = os.link

        def create_competing_file(source, target):
            target.write_text("# concurrently saved\n")
            real_link(source, target)

        result = subprocess.CompletedProcess(
            [], 0, stdout=json.dumps({"one": display()})
        )
        with (
            patch("init_displays.subprocess.run", return_value=result),
            patch("init_displays.os.link", side_effect=create_competing_file),
        ):
            initialize(self.path)
        self.assertEqual(self.path.read_text(), "# concurrently saved\n")


class SessionEnvironmentTests(unittest.TestCase):
    def test_recovers_only_niri_socket_from_user_manager(self):
        result = subprocess.CompletedProcess(
            [],
            0,
            stdout="UNRELATED=private\nNIRI_SOCKET='/run/user/1000/socket name'\n",
        )
        with (
            patch.dict(
                "os.environ",
                {"PATH": "/test", "XDG_RUNTIME_DIR": "/run/user/1024"},
                clear=True,
            ),
            patch("init_displays.subprocess.run", return_value=result),
        ):
            environment = session_environment()
        self.assertEqual(
            environment,
            {
                "PATH": "/test",
                "XDG_RUNTIME_DIR": "/run/user/1024",
                "NIRI_SOCKET": "/run/user/1000/socket name",
            },
        )


if __name__ == "__main__":
    unittest.main()
