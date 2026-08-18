{ ... }:
{
  imports = [ ../common.nix ];

  mo = {
    system = {
      wsl = false;
      bluetooth = false;
      mihomo = false;
      docker = true;
      postgres = true;
      nginx = {
        enable = true;
        virtualHosts = {
          "akiron.dev" = {
            forceSSL = true;
            locations."/".return = "301 https://www.akiron.dev$request_uri";
          };
          "www.akiron.dev" = {
            forceSSL = true;
            root = "/srv/sites/akiron.dev";
          };
          "mux.akiron.dev" = {
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:17322";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout 3600s;
              '';
            };
          };
        };
      };

      boot.mode = "bios";
      boot.device = "/dev/vda";

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      # firewall
      firewall.trustedInterfaces = [ ];

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      gpu.kind = [ ];
      gpu.intel-bus-id = "";
      gpu.amd-bus-id = "";
      gpu.nvidia-bus-id = "";
    };

    desktop.enable = false;

    programs = {
      wezterm.font-size = 14;
      zsh.promptStyle = "compact";

      firefox.enable = false;
      steam.enable = false;
      keyd.enable = false;
      keyd.settings = { };

      niri.output = "";
      niri.opacity.active = "";
      niri.opacity.inactive = "";

      ssh.enableHost = false;
      ssh.enableKey = false;
    };
  };
}
