{ config, ... }:
{
  programs.akvim = {
    enable = true;
    settings = config.mo.programs.nvim.settings;
  };
}
