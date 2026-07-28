{ config, ... }:
{
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
              opus = "deepseek-v4-pro[1m]";
              sonnet = "deepseek-v4-pro[1m]";
              haiku = "deepseek-v4-flash";
              subagent = "deepseek-v4-flash";
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
          id = "nfts";
          name = "NftsCode";
          api_url = "https://api.9527.codes";
          api_key = "env:NFTS_API_KEY";
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
      codex_providers = [
        {
          id = "nfts";
          name = "NftsCode";
          api_url = "https://api.9527.codes";
          api_key = "env:NFTS_API_KEY";
        }
      ];
    };
    envVars = config.sops.templates."ccswitch-env".path;
  };

  # sops template 会在激活时把占位符替换为实际解密后的值
  sops.templates."ccswitch-env".content = ''
    CPA_API_KEY=${config.sops.placeholder.CPA_API_KEY}
    DEEPSEEK_API_KEY=${config.sops.placeholder.DEEPSEEK_API_KEY}
    NFTS_API_KEY=${config.sops.placeholder.NFTS_API_KEY}
    OPENROUTER_API_KEY=${config.sops.placeholder.OPENROUTER_API_KEY}
    ZAI_API_KEY=${config.sops.placeholder.ZAI_API_KEY}
  '';
}
