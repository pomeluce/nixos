{ config, inputs, ... }:
{
  programs.akirnvim = {
    enable = true;
    settings = config.mo.programs.nvim.settings;
  };

  home.sessionVariables = {
    EDITOR = "av";
    VISUAL = "av";
  };
}
