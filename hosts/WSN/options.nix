{ pkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      gtk.scale = 1;

      bluetooth = false;
      mihomo = false;
      postgres = true;
      docker = true;

      wsl = true;

      desktop.enable = false;
      sddm.enable = false;
      hyprland.enable = false;
      gnome.enable = false;

      cursor.size = 24;
      cursor.theme = "Bibata-Modern-Ice";
      icon.theme = "MoreWaita";

      # user env
      session-variables = { };
      session-path = [ ];

      # proxy
      proxy.enabled = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ ];
      drive.intel-bus-id = "";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "";
    };

    programs = {
      # git config
      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";

      postgres.port = 5432;
      postgres.pkg = pkgs.postgresql_17;
      postgres.jit = "off";
      postgres.listen_addresses = "*";
      postgres.upgrade.pkg = pkgs.postgresql;

      docker.data-root = "${devroot}/env/docker/";
      docker.exec-opts = [ "native.cgroupdriver=systemd" ];
      docker.insecure-registries = [
        "10.9.161.161:1121"
        "10.9.161.171:1121"
        "10.9.47.206:1121"
        "10.9.47.201:1121"
        "10.9.47.202:1121"
        "harbor1.yx-m.paas.sh-sit-jssdn-70-253.cmit.cloud:1121"
        "harbor2.yx-m.paas.sh-sit-jssdn-70-253.cmit.cloud:1121"
      ];

      firefox.enable = false;

      wezterm.font-size = 14;
      swaylock.font-size = 22;
    };

    # packages for this machine
    packages = with pkgs; [ ];
  };
}
