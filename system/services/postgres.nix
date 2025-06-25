{ opts, ... }:
{
  services.postgresql = {
    enable = opts.system.postgres;
    dataDir = opts.programs.postgres.data-dir;
    settings = {
      port = opts.programs.postgres.port;
    };
  };
}
