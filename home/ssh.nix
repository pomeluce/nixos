{ config, lib, ... }:
let
  publicHosts = config.mo.programs.ssh.hosts;
  hostBlock = name: cfg: ''
    Host ${name}
        Hostname ${cfg.Hostname}
        Port ${toString cfg.Port}
        User ${cfg.User}
        IdentityFile ${cfg.IdentityFile}
  '';
  publicPart = lib.concatStringsSep "\n" (lib.mapAttrsToList hostBlock publicHosts);
in
{
  sops.templates."ssh-config.conf".content = ''
    ${publicPart}
    ${config.sops.placeholder.CONECLOUD_SSH_CONFIG}
  '';

  home.activation.writeSshConfig = lib.hm.dag.entryAfter [ "sops-nix" ] ''
    install -m 644 "${
      config.sops.templates."ssh-config.conf".path
    }" "${config.home.homeDirectory}/.ssh/config"
  '';
}
