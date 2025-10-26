{ lib, opts, ... }:
{
  imports =
    lib.optionals opts.system.wm.hyprland [
      ./hyprland.nix
      ./wayland.nix
    ]
    ++ lib.optionals opts.system.wm.niri [
      ./niri.nix
      ./wayland.nix
    ]
    ++ lib.optionals (!opts.system.wm.hyprland && !opts.system.wm.niri) [ ./gnome.nix ];

  config = lib.mkMerge [
    {
      services.displayManager.defaultSession = "${opts.system.dm.defaultSession}";
    }
    (lib.mkIf opts.system.wm.hyprland {
      programs.hyprland.withUWSM = true;
      programs.hyprland.enable = true;
      programs.hyprland.xwayland.enable = true;
    })
    (lib.mkIf opts.system.wm.niri {
      programs.niri.enable = true;
    })
  ];
}
