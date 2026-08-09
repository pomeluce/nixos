{ config, ... }:
{
  programs.akironvim = {
    enable = true;
    settings = config.mo.programs.nvim.settings;
  };
}
