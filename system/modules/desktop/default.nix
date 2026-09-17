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
      {
        assertions = [
          {
            assertion =
              (mo.desktop.dm.defaultSession == "niri" && mo.desktop.wm.niri)
              || (mo.desktop.dm.defaultSession == "hyprland" && mo.desktop.wm.hyprland)
              || (mo.desktop.dm.defaultSession == "gnome" && !mo.desktop.wm.niri && !mo.desktop.wm.hyprland);
            message = "mo.desktop.dm.defaultSession must name an enabled desktop session; GNOME is the fallback when no Wayland WM is selected.";
          }
        ];
        services.displayManager.defaultSession = mo.desktop.dm.defaultSession;
      }
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
