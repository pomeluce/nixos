{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myOptions.desktop;
in
{
  config = lib.mkIf (cfg.enable && !cfg.wm.hyprland && !cfg.wm.niri) {
    environment = {
      systemPackages = with pkgs; [
        morewaita-icon-theme
        adwaita-icon-theme
        whitesur-gtk-theme
        wl-clipboard

        gnomeExtensions.just-perfection
        gnomeExtensions.color-picker
        gnomeExtensions.user-themes
      ];

      gnome.excludePackages = with pkgs; [
        gnome-text-editor
        gnome-console
        gnome-photos
        gnome-tour
        gnome-connections
        gnome-contacts
        gnome-initial-setup
        gnome-disk-utility
        gnome-logs
        gnome-weather
        gnome-font-viewer
        gnome-shell-extensions
        gnome-maps
        gnome-music
        gnome-characters
        gnome-clocks
        snapshot
        gedit
        cheese # webcam tool
        epiphany # web browser
        geary # email reader
        evince # document viewer
        totem # video player
        yelp # Help view
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        simple-scan
        rhythmbox
        baobab
        decibels
        rygel
        seahorse
      ];
    };

    services.desktopManager.gnome.enable = true;
  };
}
