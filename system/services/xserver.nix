{ pkgs, opts, ... }:
let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      Font = "Inter";
      HourFormat = "HH:mm";
      DateFormat = "dddd d MMMM";
      BlurMax = "36";
    };
    # embeddedTheme = "japanese_aesthetic";
  };
in
{
  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];
      displayManager = {
        startx.enable = true;
      };
      # Configure keymap in X11
      xkb.layout = "us";
    };

    displayManager.sddm = {
      enable = opts.system.sddm.enable;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      # theme = "sddm-astronaut-theme";
      extraPackages = [ sddm-astronaut ];
    };
  };

  environment.systemPackages = [ sddm-astronaut ];
}
