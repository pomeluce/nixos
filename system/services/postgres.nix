{
  lib,
  config,
  pkgs,
  ...
}:
let
  mo = config.mo;
in
{
  config = lib.mkIf mo.system.postgres {
    services.postgresql = {
      enable = true;
      package = mo.programs.postgres.pkg;
      ensureDatabases = [ "dev" ];
      enableTCPIP = true;
      enableJIT = true;
      settings = {
        port = mo.programs.postgres.port;
        jit = mo.programs.postgres.jit;
        listen_addresses = mo.programs.postgres.listen_addresses;
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
          newPostgres = mo.programs.postgres.upgrade_pkg;
          csp = config.services.postgresql;
        in
        pkgs.writeScriptBin "pg_cluster_upgrade" ''
          # Compare old and new schema versions
          OLD_SCHEMA="${csp.finalPackage.psqlSchema}"
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

          export OLDDATA="${csp.dataDir}"
          export OLDBIN="${csp.finalPackage}/bin"

          install -d -m 0700 -o postgres -g postgres "$NEWDATA"
          cd "$NEWDATA"
          sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA" ${lib.escapeShellArgs csp.initdbArgs}

          sudo -u postgres "$NEWBIN/pg_upgrade" \
            --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
            --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
            "$@"
        ''
      )
    ];
  };
}
