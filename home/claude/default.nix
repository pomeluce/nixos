{ pkgs, config, ... }:
let
  model_path = "${config.mo.devroot}/wsp/nixos/home/claude/models.json";
in
{
  programs.claude-code = {
    enable = true;
    # settings = {
    #   env = {
    #     ANTHROPIC_BASE_URL = "https://coding.dashscope.aliyuncs.com/apps/anthropic";
    #     ANTHROPIC_MODEL = "glm-5";
    #   };
    # };
  };

  home.packages = with pkgs; [ npkgs.scripts.ccs ];
  home.file.".claude/models.json".source = config.lib.file.mkOutOfStoreSymlink model_path;
}
