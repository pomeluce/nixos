{
  lib,
  sysConfig,
  pkgs,
  ...
}:
let
  cfg = sysConfig.myOptions;
in
{

  config = lib.mkIf cfg.desktop.enable {
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

    home.file.".config/wezterm/config/domains.lua".text = ''
      local platform = require('utils.platform')()

      return {
        default_domain = platform.is_windows and 'WSL:NixOS' or 'local',
        ssh_domains = {},
        wsl_domains = {
          {
            name = 'WSL:NixOS',
            distribution = 'NixOS',
            username = '${cfg.username}',
            default_cwd = '/home/${cfg.username}',
            default_prog = { '/etc/profiles/per-user/${cfg.username}/bin/zsh', '--login' },
          },
        },
      }
    '';

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
        font_size = ${toString cfg.programs.wezterm.font-size},
      }
    '';

    home.packages = with pkgs; [
      wezterm
    ];
  };
}
