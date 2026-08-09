{ config, ... }:
{
  imports = [ ../common.nix ];

  mo = {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    system = {
      wsl = true;
      bluetooth = false;
      mihomo = false;
      docker = true;
      postgres = true;

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      gpu.kind = [ ];
      gpu.intel-bus-id = "";
      gpu.amd-bus-id = "";
      gpu.nvidia-bus-id = "";
    };

    desktop.enable = false;

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
        header.env = {
          USER = "kzuo";
        };
        lsp.jdtls = {
          maven.userSettings = "~/.m2/settings-siact.xml";
        };
      };
    };
  };
}
