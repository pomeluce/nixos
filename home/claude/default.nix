{
  lib,
  pkgs,
  config,
  ...
}:
let
  model_path = "${config.mo.devroot}/wsp/nixos/home/claude/models.json";
  ccds = pkgs.writeText "ccds.json" (
    builtins.toJSON {
      env = {
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
        CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK = 1;
        CLAUDE_CODE_EFFORT_LEVEL = "max";
      };
      enabledPlugins = {
        "superpowers@claude-plugins-official" = true;
      };
      language = "Chinese";
    }
  );
in
{
  programs.claude-code = {
    enable = true;
  };
  home.packages = with pkgs; [ npkgs.scripts.ccs ];
  home.file.".claude/models.json".source = config.lib.file.mkOutOfStoreSymlink model_path;
  home.file.".claude/settings.nix-default.json".source = ccds;

  # 已有 settings.json 里的值优先, 避免覆盖插件写入的内容
  home.activation.mergeCCSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    export PATH="${
      lib.makeBinPath [
        pkgs.jq
        pkgs.coreutils
      ]
    }:$PATH"

    dir="$HOME/.claude"
    target="$dir/settings.json"

    mkdir -p "$dir"

    if [ ! -e "$target" ]; then
      jq . ${ccds} > "$target"
      chmod u+rw "$target"
      exit 0
    fi

    if ! jq empty "$target" >/dev/null 2>&1; then
      backup="$target.invalid.$(date +%s)"
      cp "$target" "$backup"
      jq . ${ccds} > "$target"
      chmod u+rw "$target"
      echo "warning: invalid Claude Code settings backed up to $backup"
      exit 0
    fi

    tmp="$(mktemp)"

    # 合并规则: 以用户/插件已经写入的配置优先
    jq -s '.[0] * .[1]' ${ccds} "$target" > "$tmp"

    mv "$tmp" "$target"
    chmod u+rw "$target"
  '';
}
