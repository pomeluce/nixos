{ config, ... }:
{
  imports = [ ../common.nix ];

  mo = {
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
    };

    desktop = {
      enable = false;
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

      wallpaper.enable = false;
    };

    programs = {
      wezterm.font-size = 14;

      firefox.enable = false;
      steam.enable = false;
      keyd.enable = false;
      keyd.settings = { };

      niri.output = "";
      niri.opacity.active = "";
      niri.opacity.inactive = "";

      ssh.hosts = {
        "github.com" = {
          HostName = "ssh.github.com";
          Port = 443;
          IdentityFile = "~/.ssh/id_github";
        };
        "192.100.30.115" = {
          HostName = "192.100.30.115";
          IdentityFile = "~/.ssh/id_gitlab";
        };
        "192.100.2.171" = {
          HostName = "192.100.2.171";
          IdentityFile = "~/.ssh/id_gitlab";
        };
        dev = {
          HostName = "192.100.2.171";
          IdentityFile = "~/.ssh/id_ssh";
        };
        algorithm = {
          HostName = "192.100.6.88";
          IdentityFile = "~/.ssh/id_ssh";
        };
        conevps = {
          HostName = config.sops.placeholder.VPS_CONE_IP;
          Port = config.sops.placeholder.VPS_CONE_PORT;
          IdentityFile = "~/.ssh/id_ssh";
        };
        rackvps = {
          HostName = config.sops.placeholder.VPS_RACK_IP;
          Port = config.sops.placeholder.VPS_RACK_PORT;
          IdentityFile = "~/.ssh/id_ssh";
        };
      };

      nvim.settings = {
        header = {
          python = ''
            """
            author      : kzuo
            version     : 1.0
            date        : {DATE} {TIME}
            module      : {FILE_NAME}
            description : (TODO: 描述该模块的功能)
            """
          '';
        };
        lsp.jdtls = {
          maven.userSettings = "~/.m2/settings-siact.xml";
          runtimes = [
            {
              name = "JavaSE-1.8";
              path = "/etc/jdk/zulu8";
              default = true;
            }
            {
              name = "JavaSE-21";
              path = "/etc/jdk/zulu21";
            }
            {
              name = "JavaSE-25";
              path = "/etc/jdk/zulu25";
            }
          ];
        };
      };
    };
  };
}
