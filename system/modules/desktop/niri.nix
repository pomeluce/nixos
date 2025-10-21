{
  config,
  lib,
  pkgs,
  npkgs,
  ...
}:
let
  nautilus-wrapper = pkgs.buildEnv {
    name = "nautilus";
    paths = with pkgs; [
      nautilus-python
      nautilus-open-any-terminal
      (pkgs.writeScriptBin "nautilus" ''
        #!/usr/bin/env bash
        # 读取用户会话中的主题(去掉单引号), 如果有则导出到 GTK_THEME
        theme="$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")"
        if [ -n "$theme" ]; then
          export GTK_THEME="$theme"
        fi
        exec ${nautilus}/bin/nautilus "$@"
      '')
    ];
  };
in
{
  environment.systemPackages = with pkgs; [
    morewaita-icon-theme
    adwaita-icon-theme
    whitesur-gtk-theme
    bibata-cursors
    loupe
    nautilus-wrapper
    gnome-control-center
    gnome-calendar
    gnome-system-monitor
    gnome-calculator
    gsettings-desktop-schemas
    wl-clipboard
    xwayland-satellite
    xorg.xrdb
    fprintd
    akirshell.akir-shell
    akirshell.screenrecord
    npkgs.scripts.screenshot
  ];
  environment.pathsToLink = [
    "/share/nautilus-python/extensions"
  ];
  environment.sessionVariables = {
    FILE_MANAGER = "nautilus";
    NAUTILUS_4_EXTENSION_DIR = lib.mkDefault "${nautilus-wrapper}/lib/nautilus/extensions-4";
  };
}
