{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = config.mo.username;
  devspace = config.mo.devspace;
in
{
  mo = {
    username = lib.mkDefault "Tso";
    uid = 1000;
    gid = 1000;
    devspace = lib.mkDefault "/home/${username}/devspace";

    system = {
      # virtualisation defaults
      virt.enable = lib.mkDefault false;
      virt.kvm-cpu-type = lib.mkDefault "intel"; # "intel" or "amd"
      virt.kvm-gpu-ids = lib.mkDefault [
        "10de:28e0" # Graphics
        "10de:22be" # Audio
      ];

      # boot loader defaults
      boot.mode = lib.mkDefault "efi";
      boot.device = lib.mkDefault "nodev";

      # user env
      session-variables = lib.mkDefault { };
      session-path = lib.mkDefault [ ];
    };

    desktop = {
      cursor.size = lib.mkDefault 24;
      cursor.theme = lib.mkDefault "Bibata-Modern-Ice";
      icon.theme = lib.mkDefault "MoreWaita";

      wallpaper.dir = lib.mkDefault "${devspace}/repos/wallpapers/";
      wallpaper.interval = lib.mkDefault 300;
      wallpaper.fps = lib.mkDefault 165;
    };

    programs = {
      # ghostty, wezterm
      terminal = lib.mkDefault "ghostty";

      git.name = lib.mkDefault "Tso";
      git.email = lib.mkDefault "62343478+pomeluce@users.noreply.github.com";
      git.branch = lib.mkDefault "main";

      docker.data-root = lib.mkDefault "${devspace}/var/docker/";
      docker.exec-opts = lib.mkDefault [ "native.cgroupdriver=systemd" ];
      docker.insecure-registries = lib.mkDefault [ ];
      docker.registry-mirrors = lib.mkDefault [ ];

      postgres.pkg = lib.mkDefault pkgs.postgresql_18;
      postgres.upgrade_pkg = lib.mkDefault pkgs.postgresql_17;
      postgres.port = lib.mkDefault 5432;
      postgres.jit = lib.mkDefault "off";
      postgres.listen_addresses = lib.mkDefault "*";

      swaylock.font-size = lib.mkDefault 14;

      nvim.settings = lib.mkDefault {
        session = {
          projects = [
            "$DEVSPACE/code/projects/*"
            "$DEVSPACE/code/experiments/*"
            "$DEVSPACE/code/archived/*"
            "$DEVSPACE/images/*"
            "$DEVSPACE/infra/*"
            "$DEVSPACE/repos/*"
            "$DEVSPACE/work"
          ];
          ignore_dir = [ "$XDG_DOWNLOAD_DIR" ];
        };
        lsp.jdtls = {
          maven = {
            globalSettings = "~/.m2/settings.xml";
          };
          runtimes = [
            {
              name = "JavaSE-1.8";
              path = "/etc/jdk/zulu8";
            }
            {
              name = "JavaSE-21";
              path = "/etc/jdk/zulu21";
              default = true;
            }
            {
              name = "JavaSE-25";
              path = "/etc/jdk/zulu25";
            }
          ];
        };
      };

      ssh.ports = [
        22
        2200
      ];
    };

    userPackages = lib.mkDefault [ ];
  };
}
