{
  # Dbus
  services.dbus.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # rtkit
  security.rtkit.enable = true;
  # usbmuxd
  services.usbmuxd.enable = true;
  # fwupd
  services.fwupd.enable = true;
}
