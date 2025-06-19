{ pkgs, opts, ... }:
{
  home.file.".config/wezterm/wezterm.lua" = {
    source = ./wezterm.lua;
  };

  home.file.".config/wezterm/colors" = {
    recursive = true;
    source = ./colors;
  };

  home.file.".config/wezterm/config" = {
    recursive = true;
    source = ./config;
  };

  home.file.".config/wezterm/events" = {
    recursive = true;
    source = ./events;
  };

  home.file.".config/wezterm/utils" = {
    recursive = true;
    source = ./utils;
  };

  home.file.".config/wezterm/utils/nix.lua".text = ''
    return {
      font_size = ${toString opts.system.fontSize.wezterm},
    }
  '';

  home.packages = with pkgs; [
    wezterm
  ];
}
