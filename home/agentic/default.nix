{
  config,
  lib,
  pkgs,
  ...
}:
let
  agentic = config.mo.agentic;
  agentsSource = "${config.mo.devspace}/repos/nixos/home/agentic/.agents";
  agentsFile = config.lib.file.mkOutOfStoreSymlink "${agentsSource}/AGENTS.md";
  agentsSkills = config.lib.file.mkOutOfStoreSymlink "${agentsSource}/skills";
  mattPocockSkillsRepo = "https://github.com/mattpocock/skills.git";
in
{
  imports = [
    ./ccswitch.nix
    ./claude
    ./codex.nix
    ./pi.nix
  ];

  home.file = lib.mkMerge [
    (lib.mkIf agentic.enable {
      ".agents/AGENTS.md".source = agentsFile;
      ".agents/skills".source = agentsSkills;
    })
    (lib.mkIf (agentic.enable && agentic.claude) {
      ".claude/CLAUDE.md".source = agentsFile;
      ".claude/skills".source = agentsSkills;
    })
    (lib.mkIf (agentic.enable && agentic.codex) {
      ".codex/AGENTS.md".source = agentsFile;
    })
    (lib.mkIf (agentic.enable && agentic.pi) {
      ".pi/agent/AGENTS.md".source = agentsFile;
    })
  ];

  home.activation = lib.mkIf agentic.enable {
    ensureWorkbench = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -euo pipefail
      mkdir -p "${config.home.homeDirectory}/workbench"
    '';

    installMattPocockSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -euo pipefail

      export PATH="${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.findutils
          pkgs.git
          pkgs.gnugrep
        ]
      }:$PATH"

      repo="$HOME/.local/share/agentic/sources/mattpocock-skills"
      sharedSkills="${agentsSource}/skills"
      desiredSkills="$(mktemp)"
      trap 'rm -f "$desiredSkills"' EXIT

      if [ ! -e "$repo" ]; then
        mkdir -p "$(dirname "$repo")"
        git clone --depth 1 "${mattPocockSkillsRepo}" "$repo"
      elif [ ! -d "$repo/.git" ]; then
        echo "error: $repo exists but is not a Git repository" >&2
        exit 1
      elif ! git -C "$repo" pull --ff-only; then
        echo "warning: failed to update Matt Pocock skills; using the existing checkout" >&2
      fi

      linkSkill() {
        src="$1"
        dest="$2"
        target="$dest/$(basename "$src")"

        mkdir -p "$dest"

        if [ -L "$target" ]; then
          linkTarget="$(readlink "$target")"
          case "$linkTarget" in
            "$repo"/skills/*)
              if [ "$linkTarget" != "$src" ]; then
                replacement="$dest/.$(basename "$src").tmp.$$"
                ln -s "$src" "$replacement"
                mv -Tf "$replacement" "$target"
              fi
              ;;
            *)
              echo "warning: skipping unmanaged symlink $target" >&2
              ;;
          esac
        elif [ -e "$target" ]; then
          echo "warning: skipping unmanaged path $target" >&2
        else
          ln -s "$src" "$target"
        fi
      }

      while IFS= read -r -d "" skillFile; do
        skillDir="$(dirname "$skillFile")"
        basename "$skillDir" >> "$desiredSkills"
        linkSkill "$skillDir" "$sharedSkills"
      done < <(
        find "$repo/skills" \
          -name SKILL.md \
          -not -path "*/node_modules/*" \
          -not -path "*/deprecated/*" \
          -print0
      )

      # Remove only managed links that no longer exist in the upstream checkout.
      while IFS= read -r -d "" target; do
        linkTarget="$(readlink "$target")"
        case "$linkTarget" in
          "$repo"/skills/*)
            if ! grep -Fxq -- "$(basename "$target")" "$desiredSkills"; then
              rm "$target"
            fi
            ;;
        esac
      done < <(find "$sharedSkills" -mindepth 1 -maxdepth 1 -type l -print0)
    '';
  };
}
