{ pkgs, opts, ... }:
let
  bg = pkgs.fetchurl {
    url = "https://www.desktophut.com/files/ymkspRzeH0-wallpaper.mp4";
    hash = "sha256-WG8UI10NA4EAx63SU4Wb8x0r2TX7bOT5qLB1jKaSTKg=";
  };
  silent = pkgs.silent.override {
    theme = "default";
    extraBackgrounds = [ bg ];
    theme-overrides = {
      "LoginScreen" = {
        background = "${bg.name}";
      };
      "LockScreen" = {
        background = "${bg.name}";
      };
    };
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

    displayManager = {
      sddm = {
        enable = opts.system.sddm.enable;
        wayland.enable = true;
        enableHidpi = true;
        package = pkgs.kdePackages.sddm;
        theme = silent.pname;
        extraPackages = silent.propagatedBuildInputs;
        settings = {
          # required for styling the virtual keyboard
          General = {
            GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=${toString (builtins.floor (opts.system.qt.scale))},QT_FONT_DPI=${
              toString (builtins.floor (96 * opts.system.qt.scale))
            },QML2_IMPORT_PATH=${silent}/share/sddm/themes/${silent.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };
      defaultSession = "hyprland-uwsm";
    };
  };

  environment.systemPackages = [ silent ];
}
