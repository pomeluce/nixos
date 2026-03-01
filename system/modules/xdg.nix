{
  config,
  lib,
  pkgs,
  ...
}:
let
  mo = config.mo;
in
{
  config = lib.mkIf mo.desktop.enable {
    xdg.portal = {
      enable = true;
      extraPortals =
        with pkgs;
        [ xdg-desktop-portal-gtk ]
        ++ lib.optionals mo.desktop.wm.niri [ xdg-desktop-portal-gnome ]
        ++ lib.optionals mo.desktop.wm.hyprland [ xdg-desktop-portal-hyprland ];
    };
  };
}
