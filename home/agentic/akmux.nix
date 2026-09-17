{ config, lib, ... }:
let
  agentic = config.mo.agentic;
in
lib.mkIf (agentic.enable && agentic.ccswitch) {
  programs.akmux = {
    enable = true;
    gui = agentic.akmux.gui;
    defaults = {
      version = 1;
      claude_providers = [
        {
          id = "deepseek";
          name = "DeepSeek";
          api_url = "https://api.deepseek.com/anthropic";
          api_key = "env:DEEPSEEK_API_KEY";
          profiles = [
            {
              id = "flash";
              name = "DeepSeek-Flash";
              opus = "deepseek-flash[1m]";
              sonnet = "deepseek-flash[1m]";
              haiku = "deepseek-flash";
              subagent = "deepseek-flash";
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
        {
          id = "deepseek";
          name = "DeepSeek";
          api_url = "https://api.deepseek.com";
          api_key = "env:DEEPSEEK_API_KEY";
          codex_catalog = "custom";
          models = [
            {
              slug = "deepseek-v4-pro";
              display_name = "Deepseek-v4-Pro";
              description = "Most capable frontier agentic coding model.";
              context_window = 1048576;
              max_context_window = 1048576;
              effective_context_window_percent = 95;
              default_reasoning_effort = "high";
              supported_reasoning_efforts = [
                "low"
                "high"
                "max"
              ];
              input_modalities = [ "text" ];
              supports_parallel_tool_calls = true;
              support_verbosity = true;
              supports_search_tool = true;
              default_verbosity = "low";
              default = true;
            }
            {
              slug = "deepseek-flash";
              display_name = "Deepseek-Flash";
              description = "Latest frontier agentic coding model with image input.";
              context_window = 1048576;
              max_context_window = 1048576;
              effective_context_window_percent = 95;
              default_reasoning_effort = "high";
              supported_reasoning_efforts = [
                "low"
                "high"
                "max"
              ];
              input_modalities = [
                "text"
                "image"
              ];
              supports_parallel_tool_calls = true;
              support_verbosity = true;
              supports_search_tool = true;
              default_verbosity = "low";
              default = false;
            }
          ];
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
