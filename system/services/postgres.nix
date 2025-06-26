{
  lib,
  opts,
  config,
  pkgs,
  ...
}:
{
  services.postgresql = {
    enable = opts.system.postgres;
    package = opts.programs.postgres.pkg;
    ensureDatabases = [ "dev" ];
    enableTCPIP = true;
    settings = {
      port = opts.programs.postgres.port;
    };
    # initialScript = ''
    #
    # '';
    authentication = lib.mkForce ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             postgres                                peer
      local   all             all                                     scram-sha-256
      host    all             all             0.0.0.0/0               scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
    '';
  };

  environment.systemPackages = (lib.mkIf opts.programs.postgres.upgrade.enable) [
    (
      let
        newPostgres = opts.programs.postgres.upgrade.new-pkg;
        cfg = config.services.postgresql;
      in
      pkgs.writeScriptBin "pg_cluster_upgrade" ''
        set -eux
        systemctl stop postgresql

        export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
        export NEWBIN="${newPostgres}/bin"

        export OLDDATA="${cfg.dataDir}"
        export OLDBIN="${cfg.finalPackage}/bin"

        install -d -m 0700 -o postgres -g postgres "$NEWDATA"
        cd "$NEWDATA"
        sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA" ${lib.escapeShellArgs cfg.initdbArgs}

        sudo -u postgres "$NEWBIN/pg_upgrade" \
          --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
          --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
          "$@"
      ''
    )
  ];
}
