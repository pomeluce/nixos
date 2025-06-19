{
  lib,
  pkgs,
  opts,
  ...
}:
{
  config = lib.mkIf opts.system.wm.hyprland {
    programs.hyprland.withUWSM = true;
    programs.hyprland.enable = true;

    services.logind.extraConfig = ''
      HandlePowerKey=ignore
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=ignore
    '';

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };

    security = {
      polkit.enable = true;
      # pam.services.astal-auth = { };
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

    systemd.tmpfiles.rules = [
      "d '/var/cache/greeter' - greeter greeter - -"
    ];
  };
}
