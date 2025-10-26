{ pkgs, opts, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals =
      with pkgs;
      [
        xdg-desktop-portal-gtk
      ]
      ++ lib.optionals opts.system.wm.niri [
        xdg-desktop-portal-gnome
      ]
      ++ lib.optionals opts.system.wm.hyprland [
        xdg-desktop-portal-hyprland
      ];
  };
}
