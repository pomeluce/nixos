{ config, lib, ... }:
let
  cfg = config.myOptions.desktop;
in
{
  imports = [
    ./niri.nix
    ./hyprland.nix
    ./wayland.nix
    ./gnome.nix
  ];

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { services.displayManager.defaultSession = cfg.dm.defaultSession; }
      (lib.mkIf cfg.wm.hyprland {
        programs.hyprland.withUWSM = true;
        programs.hyprland.enable = true;
        programs.hyprland.xwayland.enable = true;
      })
      (lib.mkIf cfg.wm.niri {
        programs.niri.enable = true;
      })
    ]
  );
}
