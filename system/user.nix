{ config, pkgs, ... }:
let
  cfg = config.myOptions;
  name = cfg.username;
  avatarSrc = ../assets/avatar.png;
in
{
  # Define a user group
  users.groups = {
    "${name}" = {
      gid = cfg.gid;
    };
  };
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.${name} = {
    isNormalUser = true;
    uid = cfg.uid;
    extraGroups = [
      name
      "networkmanager"
      "wheel"
      "video"
      "libvirtd"
      "docker"
    ]; # Enable 'sudo' for the user.
    shell = pkgs.zsh;
  };

  system.activationScripts.userAvatar = ''
    install -Dm644 ${avatarSrc} /var/lib/AccountsService/icons/${name}
  '';
}
