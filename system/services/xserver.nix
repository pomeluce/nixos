{ pkgs, opts, ... }:
let
  silent = pkgs.silent.override { theme = "catppuccin-frappe"; };
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
            GreeterEnvironment = "QML2_IMPORT_PATH=${silent}/share/sddm/themes/${silent.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };
      defaultSession = "hyprland-uwsm";
    };
  };

  environment.systemPackages = [ silent ];
}
