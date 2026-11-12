import json
import tempfile
import unittest
from pathlib import Path
from profile import configure, switch_value

DEFAULTS = {
    "bookmark_bar": {"show_tab_groups": False},
    "profile": {"name": "marcus", "using_default_name": False},
    "vertical_tabs": {"enabled": True, "collapsed_state": True},
    "in_product_help": {"ntp_promos": {"disabled": True}},
}


class ProfileTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

    def write(self, name, data):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(data))
        return path

    def test_existing_profile_and_name_cache_are_updated_without_data_loss(self):
        path = self.write(
            "Default/Preferences",
            {
                "bookmark_bar": {"show_tab_groups": True, "show_on_all_tabs": True},
                "profile": {"name": "工作", "using_default_name": True},
                "vertical_tabs": {"collapsed_state": False},
                "unrelated": {"keep": [1, 2]},
            },
        )
        state = self.write(
            "Local State",
            {
                "profile": {
                    "info_cache": {
                        "Default": {"name": "工作", "is_using_default_name": True},
                        "Profile 1": {"name": "Other"},
                    }
                }
            },
        )
        configure(self.root, None, DEFAULTS)
        result = json.loads(path.read_text())
        self.assertEqual(result["profile"]["name"], "marcus")
        self.assertFalse(result["bookmark_bar"]["show_tab_groups"])
        self.assertTrue(result["bookmark_bar"]["show_on_all_tabs"])
        self.assertTrue(result["vertical_tabs"]["collapsed_state"])
        self.assertTrue(result["in_product_help"]["ntp_promos"]["disabled"])
        self.assertEqual(result["unrelated"], {"keep": [1, 2]})
        cache = json.loads(state.read_text())["profile"]["info_cache"]
        self.assertEqual(cache["Default"]["name"], "marcus")
        self.assertFalse(cache["Default"]["is_using_default_name"])
        self.assertEqual(cache["Profile 1"], {"name": "Other"})
        configure(self.root, None, DEFAULTS)
        self.assertEqual(json.loads(path.read_text()), result)

    def test_running_browser_files_are_never_modified(self):
        path = self.write("Default/Preferences", {"profile": {"name": "工作"}})
        original = path.read_bytes()
        (self.root / "SingletonLock").symlink_to("host-12345")
        configure(self.root, None, DEFAULTS)
        self.assertEqual(path.read_bytes(), original)

    def test_last_used_profile_is_selected(self):
        self.write("Local State", {"profile": {"last_used": "Profile 1"}})
        configure(self.root, None, DEFAULTS)
        self.assertTrue((self.root / "Profile 1/Preferences").exists())
        self.assertFalse((self.root / "Default/Preferences").exists())

    def test_invalid_json_is_preserved(self):
        path = self.write("Default/Preferences", {})
        path.write_text("invalid JSON")
        with self.assertRaises(ValueError):
            configure(self.root, None, DEFAULTS)
        self.assertEqual(path.read_text(), "invalid JSON")

    def test_profile_directory_must_stay_inside_user_data(self):
        with self.assertRaises(ValueError):
            configure(self.root, "../outside", DEFAULTS)

    def test_custom_user_data_switch_formats(self):
        self.assertEqual(
            switch_value(["--user-data-dir=/tmp/a"], "--user-data-dir", None), "/tmp/a"
        )
        self.assertEqual(
            switch_value(["--user-data-dir", "/tmp/b"], "--user-data-dir", None),
            "/tmp/b",
        )


if __name__ == "__main__":
    unittest.main()
