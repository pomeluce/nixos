{
  lib,
  pkgs,
  npkgs,
  ...
}:
let
  nautEnv = pkgs.buildEnv {
    name = "nautilus";
    paths = with pkgs; [
      nautilus
      nautilus-python
      nautilus-open-any-terminal
    ];
  };
in
{
  programs.hyprland.withUWSM = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
  };

  environment.systemPackages = with pkgs; [
    morewaita-icon-theme
    adwaita-icon-theme
    whitesur-gtk-theme
    bibata-cursors
    loupe
    nautEnv
    gnome-control-center
    gnome-calendar
    gnome-system-monitor
    gnome-calculator
    wl-clipboard
    ashell.akir-shell
    ashell.screenrecord
    npkgs.scripts.screenshot
    xorg.xrdb
    fprintd
  ];
  environment.pathsToLink = [
    "/share/nautilus-python/extensions"
  ];
  environment.sessionVariables = {
    FILE_MANAGER = "nautilus";
    NAUTILUS_4_EXTENSION_DIR = lib.mkDefault "${nautEnv}/lib/nautilus/extensions-4";
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

  environment.variables.NIXOS_OZONE_WL = "1";
}
