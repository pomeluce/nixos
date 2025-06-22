{
  pkgs,
  opts,
  ...
}:
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
    nautilus
    gnome-control-center
    gnome-calendar
    gnome-system-monitor
    gnome-calculator
    wl-clipboard
    ashell.akir-shell
    ashell.screenrecord
    ashell.screenshot
    xorg.xrdb
    fprintd
  ];

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

  services.greetd = {
    enable = opts.system.wm.greetd;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --remember \
          --remember-session \
          --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red';
        '';
        user = opts.username;
      };
    };
  };
}
