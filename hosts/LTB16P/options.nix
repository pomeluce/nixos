{ pkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      gtk.scale = 1;

      bluetooth = true;
      mihomo = true;
      postgres = true;
      docker = false;

      wsl = false;

      desktop.enable = true;
      sddm.enable = true;
      hyprland.enable = true;
      gnome.enable = true;

      cursor.size = 36;
      cursor.theme = "Bibata-Modern-Ice";
      icon.theme = "MoreWaita";

      # user env
      session-variables = {
        IDEA_JDK = "${pkgs.jetbrains.jdk}/lib/openjdk";
      };
      session-path = [ ];

      # proxy
      proxy.enabled = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ "intel-nvidia" ];
      drive.intel-bus-id = "PCI:0:2:0";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "PCI:1:0:0";
    };

    programs = {
      # git config
      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";

      postgres.port = 5432;
      postgres.data-dir = "${devroot}/env/postgres";

      docker.data-root = "${devroot}/env/docker/";
      docker.exec-opts = [ "native.cgroupdriver=systemd" ];
      docker.insecure-registries = [ ];

      firefox.enable = true;

      wezterm.font-size = 20;
      swaylock.font-size = 32;
    };

    # packages for this machine
    packages = with pkgs; [
      jetbrains.jdk
      jetbrains.idea-ultimate
      vscode
      telegram-desktop
      spotify
      steam
      reqable
      nur.repos.novel2430.wpsoffice-365
      nur.repos.novel2430.wechat-universal-bwrap
      nur.repos.xddxdd.qq
    ];
  };
}
