{
  lib,
  config,
  pkgs,
  ...
}:
let
  ccds = pkgs.writeText "ccds.json" (
    builtins.toJSON {
      attribution = {
        "commit" = "";
        "pr" = "";
      };
      enabledPlugins = {
        "superpowers@claude-plugins-official" = true;
      };
      env = {
        CLAUDE_CODE_ATTRIBUTION_HEADER = 0;
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
        CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK = 1;
        CLAUDE_CODE_EFFORT_LEVEL = "max";
      };
      language = "Chinese";
      statusLine = {
        type = "command";
        command = "ccline";
        padding = 0;
      };
    }
  );
in
{
  programs.claude-code = {
    enable = true;
  };

  programs.ccswitch = {
    enable = true;
    defaults = {
      version = 1;
      providers = [
        {
          id = "deepseek";
          name = "DeepSeek";
          api_url = "https://api.deepseek.com/anthropic";
          api_key = "env:DEEPSEEK_API_KEY";
          profiles = [
            {
              id = "v4";
              name = "DeepSeek-V4";
              reasoning_model = "deepseek-v4-pro[1m]";
              task_model = "deepseek-v4-flash";
              default = true;
            }
          ];
        }
        {
          id = "zai";
          name = "ZBigModel";
          api_url = "https://api.z.ai/api/anthropic";
          api_key = "env:ZAI_API_KEY";
        }
        {
          id = "openrouter";
          name = "OpenRouter";
          api_url = "https://openrouter.ai/api";
          api_key = "env:OPENROUTER_API_KEY";
        }
        {
          id = "cpa";
          name = "CliProxyAPI";
          api_url = "http://127.0.0.1:8317";
          api_key = "env:CPA_API_KEY";
        }
      ];
    };
    envVars = config.sops.templates."ccswitch-env".path;
  };

  # sops template 会在激活时把占位符替换为实际解密后的值
  sops.templates."ccswitch-env".content = ''
    CPA_API_KEY=${config.sops.placeholder.CPA_API_KEY}
    DEEPSEEK_API_KEY=${config.sops.placeholder.DEEPSEEK_API_KEY}
    OPENROUTER_API_KEY=${config.sops.placeholder.OPENROUTER_API_KEY}
    ZAI_API_KEY=${config.sops.placeholder.ZAI_API_KEY}
  '';

  home.packages = with pkgs; [ ccline ];
  home.file.".claude/ccline/config.toml".source = ./cclc.toml;
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
