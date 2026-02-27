{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myOptions;
in
{
  config = lib.mkIf cfg.desktop.enable {
    xdg.portal = {
      enable = true;
      extraPortals =
        with pkgs;
        [ xdg-desktop-portal-gtk ]
        ++ lib.optionals cfg.desktop.wm.niri [ xdg-desktop-portal-gnome ]
        ++ lib.optionals cfg.desktop.wm.hyprland [ xdg-desktop-portal-hyprland ];
    };
  };
}
