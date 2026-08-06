{ config, lib, ... }:
let
  mo = config.mo;
in
{
  imports = [
    ./niri.nix
    ./hyprland.nix
    ./wayland.nix
    ./gnome.nix
  ];

  config = lib.mkIf mo.desktop.enable (
    lib.mkMerge [
      { services.displayManager.defaultSession = mo.desktop.dm.defaultSession; }
      (lib.mkIf mo.desktop.wm.hyprland {
        programs.hyprland.withUWSM = true;
        programs.hyprland.enable = true;
        programs.hyprland.xwayland.enable = true;
      })
      (lib.mkIf mo.desktop.wm.niri {
        programs.niri.enable = true;
      })
    ]
  );
}
