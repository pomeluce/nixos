{ pkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      gtk.scale = 1;
      qt.scale = 1;

      bluetooth = false;
      mihomo = false;
      postgres = true;
      docker = true;
      wsl = true;

      desktop.enable = false;
      wm.niri = false;
      wm.hyprland = false;
      dm.defaultSession = "niri";
      sddm.enable = false;

      cursor.size = 24;
      cursor.theme = "Bibata-Modern-Ice";
      icon.theme = "MoreWaita";

      wallpaper.enable = false;
      wallpaper.dir = "/home/${username}/.config/wallpapers/";
      wallpaper.interval = 300;
      wallpaper.fps = 165;

      # user env
      session-variables = { };
      session-path = [ ];

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
    };

    programs = {
      docker.data-root = "${devroot}/env/docker/";
      docker.exec-opts = [ "native.cgroupdriver=systemd" ];
      docker.insecure-registries = [ ];
      docker.registry-mirrors = [ ];

      firefox.enable = false;

      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";

      keyd.enable = false;
      keyd.settings = { };

      niri.output = '''';
      niri.opacity.active = "";
      niri.opacity.inactive = "";

      postgres.port = 5432;
      postgres.pkg = pkgs.postgresql_17;
      postgres.jit = "off";
      postgres.listen_addresses = "*";
      postgres.upgrade.pkg = pkgs.postgresql;

      steam.enable = false;
      swaylock.font-size = 22;

      # ghostty, wezterm
      terminal = "ghostty";
      wezterm.font-size = 14;
    };

    # packages for this machine
    packages = [ ];
  };
}
