{ config, lib, ... }:
let
  publicHosts = config.mo.programs.ssh.hosts;
  hostBlock = name: cfg: ''
    Host ${name}
        HostName ${cfg.HostName}
        Port ${toString cfg.Port}
        ${lib.optionalString (cfg.User != null) "User ${cfg.User}"}
        IdentityFile ${cfg.IdentityFile}
  '';
  publicPart = lib.concatStringsSep "\n" (lib.mapAttrsToList hostBlock publicHosts);
in
lib.mkIf config.mo.programs.ssh.enableHost {
  sops.templates."ssh-config.conf".content = ''
    ${publicPart}
  '';

  home.activation.writeSshConfig = lib.hm.dag.entryAfter [ "sops-nix" ] ''
    install -m 644 "${
      config.sops.templates."ssh-config.conf".path
    }" "${config.home.homeDirectory}/.ssh/config"
  '';
}
