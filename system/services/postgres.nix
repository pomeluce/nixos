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
    enableJIT = true;
    settings = {
      port = opts.programs.postgres.port;
      jit = opts.programs.postgres.jit;
      listen_addresses = opts.programs.postgres.listen_addresses;
    };
    initialScript = config.sops.secrets.PG_INITIAL.path;
    initdbArgs = [
      "--locale=zh_CN.UTF-8"
      "-E"
      "UTF8"
    ];
    authentication = lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             postgres                                peer
      local   all             all                                     scram-sha-256
      host    all             all             0.0.0.0/0               scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
    '';
  };

  environment.systemPackages = [
    (
      let
        newPostgres = opts.programs.postgres.upgrade.pkg;
        cfg = config.services.postgresql;
      in
      pkgs.writeScriptBin "pg_cluster_upgrade" ''
        # Compare old and new schema versions
        OLD_SCHEMA="${cfg.finalPackage.psqlSchema}"
        NEW_SCHEMA="${newPostgres.psqlSchema}"

        if [ "$NEW_SCHEMA" = "$OLD_SCHEMA" ]; then
          echo "PostgreSQL schema version unchanged ($OLD_SCHEMA); skipping upgrade."
          # Optionally, you can perform any lightweight adjustments here
          exit 0
        fi

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
