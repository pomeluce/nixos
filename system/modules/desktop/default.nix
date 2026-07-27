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
        # TIP: 暂时修复由上游 libdisplay 更新导致的 niri 编译失败问题
        programs.niri.package = pkgs.niri.override {
          libdisplay-info = pkgs.libdisplay-info.overrideAttrs (finalAttrs: {
            version = "0.3.0";
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "emersion";
              repo = "libdisplay-info";
              rev = finalAttrs.version;
              sha256 = "sha256-nXf2KGovNKvcchlHlzKBkAOeySMJXgxMpbi5z9gLrdc=";
            };
          });
        };
      })
    ]
  );
}
