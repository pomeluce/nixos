{ config, ... }:
{
  programs.akirnvim = {
    enable = true;
    settings = config.mo.programs.nvim.settings;
  };
}
