{ config, pkgs, ... }:
{
  programs.akirnvim = {
    enable = true;
    settings = config.mo.programs.nvim.settings;
    extraPackages = with pkgs.unsmall; [ vue-language-server ];
  };
}
