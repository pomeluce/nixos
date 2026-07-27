{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWayland = config.mo.desktop.wm.hyprland || config.mo.desktop.wm.niri;
in
{
  config = lib.mkIf (config.mo.desktop.enable && isWayland) {
    programs.kdeconnect.enable = true;

    services.logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "ignore";
    };

    security = {
      polkit.enable = true;
      pam.services.swaylock = { };
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    services = {
      gvfs.enable = true;
      devmon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = true;
      accounts-daemon.enable = true;
      gnome = {
        evolution-data-server.enable = true;
        glib-networking.enable = true;
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
        localsearch.enable = true;
        tinysparql.enable = true;
      };
    };
    security.pam.services.sddm.enableGnomeKeyring = true;

    # Electron 应用启用 Wayland 原生特性, 走 text-input-v3 协议对接 fcitx5 输入法
    # (QQ/微信等 Electron 应用此前以 XWayland 运行, Chromium 在 X11 模式下无法可靠加载 fcitx im module)
    environment.variables.NIXOS_OZONE_WL = "1";
  };
}
