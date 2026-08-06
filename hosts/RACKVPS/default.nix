{ ... }:
{
  imports = [ ../common.nix ];

  mo = {
    system = {
      bluetooth = false;
      docker = true;
      mihomo = false;
      postgres = true;
      wsl = false;

      boot.mode = "bios";
      boot.device = "/dev/vda";

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

      ssh.enableHost = false;
      ssh.enableKey = false;
    };
  };
}
