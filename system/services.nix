{ pkgs, opts, ... }:
let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      Font = "Inter";
      HourFormat = "HH:mm";
      DateFormat = "dddd d MMMM";
      BlurMax = "36";
    };
    embeddedTheme = "japanese_aesthetic";
  };
in
{
  services = {
    # Dbus
    dbus.enable = true;

    # Enable touchpad support(enabled default in most desktopManager).
    libinput.enable = true;

    # Enable the X11 windowing system.
    xserver.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    # sddm
    displayManager.sddm = {
      enable = opts.wm.sddm;
      package = pkgs.kdePackages.sddm;
      # TODO: theme = "sddm-astronaut-theme";
      extraPackages = [ sddm-astronaut ];
      wayland.enable = true;
    };

    # Enable the X11 windowing system.
    xserver.displayManager.startx.enable = true;

    # Configure keymap in X11
    xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # services.printing.enable = true;
  };

  environment.systemPackages = [ sddm-astronaut ];
}
