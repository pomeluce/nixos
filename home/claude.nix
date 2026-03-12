{ pkgs, ... }:
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
}
