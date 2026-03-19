{ ... }:
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

      colorscheme = "gruvbox-material-dark-hard";

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
    };
  };
}
