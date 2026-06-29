{ config, ... }:
{
  # Dbus
  services.dbus.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = config.mo.programs.ssh.ports;
  # rtkit
  security.rtkit.enable = true;
  # usbmuxd
  services.usbmuxd.enable = true;
  # fwupd
  services.fwupd.enable = true;
}
