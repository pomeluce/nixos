{ pkgs, ... }:
{
  myOptions = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;
    devroot = "/home/${username}/devroot";

    system = {
      bluetooth = false;
      docker = true;
      mihomo = false;
      postgres = true;
      wsl = true;

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ ];
      drive.intel-bus-id = "";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "";

      # virtualisation
      virt.enable = false;
      virt.kvm-cpu-type = "intel"; # "intel" or "amd"
      virt.kvm-gpu-ids = [
        "10de:28e0" # Graphics
        "10de:22be" # Audio
      ];

      # user env
      session-variables = { };
      session-path = [ ];
    };

    desktop = {
      enable = true;
      scaling = {
        gtk = 1;
        qt = 1;
        xwayland = 1;
        sddm = 1;
      };

      wm.niri = false;
      wm.hyprland = false;
      dm.defaultSession = "niri";
      dm.sddm = false;

      cursor.size = 24;
      cursor.theme = "Bibata-Modern-Ice";
      icon.theme = "MoreWaita";

      wallpaper.enable = false;
      wallpaper.dir = "/home/${username}/.config/wallpapers/";
      wallpaper.interval = 300;
      wallpaper.fps = 165;
    };

    programs = {
      # ghostty, wezterm
      terminal = "ghostty";
      wezterm.font-size = 14;

      firefox.enable = false;
      steam.enable = false;
      keyd.enable = false;
      keyd.settings = { };

      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";

      docker.data-root = "${devroot}/env/docker/";
      docker.exec-opts = [ "native.cgroupdriver=systemd" ];
      docker.insecure-registries = [ ];
      docker.registry-mirrors = [ ];

      niri.output = "";
      niri.opacity.active = "";
      niri.opacity.inactive = "";

      postgres.pkg = pkgs.postgresql_17;
      postgres.upgrade_pkg = pkgs.postgresql;
      postgres.port = 5432;
      postgres.jit = "off";
      postgres.listen_addresses = "*";

      swaylock.font-size = 14;
    };

    userPackages = [ ];

  };
}
