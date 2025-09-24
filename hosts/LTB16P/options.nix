{ pkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      gtk.scale = 1.5;
      qt.scale = 1.4;

      bluetooth = true;
      mihomo = true;
      postgres = true;
      docker = true;
      wsl = false;

      desktop.enable = true;
      sddm.enable = true;
      hyprland.enable = true;
      gnome.enable = true;

      cursor.size = 36;
      cursor.theme = "Bibata-Modern-Ice";
      icon.theme = "MoreWaita";

      wallpaper.enable = true;
      wallpaper.dir = "/home/${username}/.config/wallpapers/";
      wallpaper.interval = 300;
      wallpaper.fps = 165;

      # user env
      session-variables = {
        FILE_MANAGER = "nautilus";
      };
      session-path = [ ];

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ "intel-nvidia" ];
      drive.intel-bus-id = "PCI:0:2:0";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "PCI:1:0:0";

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

      firefox.enable = true;

      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";

      postgres.port = 5432;
      postgres.pkg = pkgs.postgresql_17;
      postgres.jit = "off";
      postgres.listen_addresses = "*";
      postgres.upgrade.pkg = pkgs.postgresql;

      steam.enable = true;
      swaylock.font-size = 32;

      wezterm.font-size = 20;
    };

    # packages for this machine
    packages = with pkgs; [
      vscode
      telegram-desktop
      typora
      spotify
      reqable
      obsidian
      vlc
      qbittorrent-enhanced
      nur.repos.novel2430.wpsoffice-365
      nur.repos.novel2430.wechat-universal-bwrap
      qq
    ];
  };
}
