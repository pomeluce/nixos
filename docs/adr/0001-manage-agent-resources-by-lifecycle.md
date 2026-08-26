# Manage shared Agent resources by lifecycle

Authored Agent Instructions and Authored Skills remain editable canonical sources in this repository, while third-party Skill Sources are pinned as non-flake inputs and updated explicitly through `flake.lock`. A shared installer copies canonical resources under `~/.agents` and gives enabled tools aliases to those installed resources, avoiding direct tool links to the repository or Nix store.

## Consequences

Home Manager reconciles the enabled tool set and third-party Skills, while a manual installer run refreshes authored resources using the last reconciled tool set. Installed Agent Resources are generated, direct edits are overwritten, and disabling a tool removes only aliases or resources recorded as installer-owned.
