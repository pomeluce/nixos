{
  config,
  lib,
  pkgs,
  ...
}:
let
  agentic = config.mo.agentic;
  tomlFormat = pkgs.formats.toml { };

  fixedSettings = {
    model_reasoning_effort = "high";
    network_access = "enabled";
    disable_response_storage = true;
  };

  codexDefaultToml = tomlFormat.generate "codex-config-default.toml" fixedSettings;

  mergeCodexConfig = pkgs.writeText "merge-codex-config.py" ''
    import sys
    import tomlkit

    default_path, target_path = sys.argv[1], sys.argv[2]

    with open(default_path) as f:
        default = tomlkit.parse(f.read())

    with open(target_path) as f:
        doc = tomlkit.parse(f.read())

    for key, value in default.items():
        doc[key] = value.unwrap() if hasattr(value, "unwrap") else value

    sys.stdout.write(tomlkit.dumps(doc))
  '';

  pythonWithTomlkit = pkgs.python3.withPackages (p: [ p.tomlkit ]);
in
lib.mkIf (agentic.enable && agentic.codex) {
  programs.codex.enable = true;

  home.activation.mergeCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    export PATH="${
      lib.makeBinPath [
        pythonWithTomlkit
        pkgs.coreutils
      ]
    }:$PATH"

    dir="$HOME/.codex"
    target="$dir/config.toml"

    mkdir -p "$dir"

    # 首次创建: 直接落入基准配置
    if [ ! -e "$target" ]; then
      cp "${codexDefaultToml}" "$target"
      chmod u+rw "$target"
      exit 0
    fi

    tmp="$(mktemp)"

    # 合并: 固定键覆盖已有值; 解析失败则备份后落入基准配置
    if python "${mergeCodexConfig}" "${codexDefaultToml}" "$target" > "$tmp"; then
      :
    else
      backup="$target.invalid.$(date +%s)"
      cp "$target" "$backup"
      cp "${codexDefaultToml}" "$tmp"
      echo "warning: invalid codex config backed up to $backup" >&2
    fi

    mv "$tmp" "$target"
    chmod u+rw "$target"
  '';
}
