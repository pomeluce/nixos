{ lib, opts, ... }:
let
  isTargetWM = wm: opts.system.desktop.wm == wm;
in
{
  imports =
    lib.optionals (isTargetWM "hyprland") [
      ./hyprland.nix
      ./wayland.nix
    ]
    ++ lib.optionals (isTargetWM "niri") [
      ./niri.nix
      ./wayland.nix
    ]
    ++ lib.optionals (!(isTargetWM "hyprland") && !(isTargetWM "niri")) [ ./gnome.nix ];

  config = lib.mkMerge [
    (lib.mkIf (isTargetWM "hyprland") {
      programs.hyprland.withUWSM = true;
      programs.hyprland.enable = true;
      programs.hyprland.xwayland.enable = true;
      services.displayManager.defaultSession = "hyprland-uwsm";
    })
    (lib.mkIf (isTargetWM "niri") {
      programs.niri.enable = true;
      services.displayManager.defaultSession = "niri";
    })
  ];
}
