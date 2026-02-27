{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.myOptions.programs.postgres;
in
{
  config = lib.mkIf config.myOptions.system.postgres {
    services.postgresql = {
      enable = true;
      package = cfg.pkg;
      ensureDatabases = [ "dev" ];
      enableTCPIP = true;
      enableJIT = true;
      settings = {
        port = cfg.port;
        jit = cfg.jit;
        listen_addresses = cfg.listen_addresses;
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
          newPostgres = cfg.upgrade_pkg;
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
