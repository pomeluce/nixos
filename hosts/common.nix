{ pkgs, lib, ... }:
{
  mo = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;
    devroot = "/home/${username}/devroot";

    system = {
      # virtualisation defaults
      virt.enable = lib.mkDefault false;
      virt.kvm-cpu-type = lib.mkDefault "intel"; # "intel" or "amd"
      virt.kvm-gpu-ids = lib.mkDefault [
        "10de:28e0" # Graphics
        "10de:22be" # Audio
      ];

      # user env
      session-variables = lib.mkDefault { };
      session-path = lib.mkDefault [ ];
    };

    desktop = {
      cursor.size = lib.mkDefault 24;
      cursor.theme = lib.mkDefault "Bibata-Modern-Ice";
      icon.theme = lib.mkDefault "MoreWaita";

      wallpaper.dir = lib.mkDefault "/home/${username}/.config/wallpapers/";
      wallpaper.interval = lib.mkDefault 300;
      wallpaper.fps = lib.mkDefault 165;
    };

    programs = {
      # ghostty, wezterm
      terminal = lib.mkDefault "ghostty";

      git.name = lib.mkDefault "Tso";
      git.email = lib.mkDefault "62343478+pomeluce@users.noreply.github.com";
      git.branch = lib.mkDefault "main";

      docker.data-root = lib.mkDefault "${devroot}/env/docker/";
      docker.exec-opts = lib.mkDefault [ "native.cgroupdriver=systemd" ];
      docker.insecure-registries = lib.mkDefault [ ];
      docker.registry-mirrors = lib.mkDefault [ ];

      postgres.pkg = lib.mkDefault pkgs.postgresql_17;
      postgres.upgrade_pkg = lib.mkDefault pkgs.postgresql;
      postgres.port = lib.mkDefault 5432;
      postgres.jit = lib.mkDefault "off";
      postgres.listen_addresses = lib.mkDefault "*";

      swaylock.font-size = lib.mkDefault 14;
    };

    userPackages = lib.mkDefault [ ];
  };
}