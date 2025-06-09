{ pkgs, opts, ... }:
let
  name = opts.username;
in
{
  # Define a user group
  users.groups = {
    "${name}" = {
      gid = 1000;
    };
  };
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.${name} = {
    isNormalUser = true;
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
}
