{
  config,
  lib,
  ...
}:
let
  mo = config.mo;
in
{
  sops = {
    defaultSopsFile = ../../secrets/system.yaml;
    age = {
      generateKey = true;
      keyFile = "/etc/ssh/age/keys.txt";
    };

    secrets.ACCESS_TOKEN = {
      mode = "0400";
      owner = config.users.users."${mo.username}".name;
    };
    secrets.MIHOMO_PROVIDER = { };
    secrets.PG_INITIAL = lib.mkIf mo.system.postgres {
      sopsFile = ../../secrets/postgres.yaml;
      mode = "0400";
      owner = config.users.users.postgres.name;
    };

    secrets.SSL_CF_PEM = lib.mkIf mo.system.nginx.enable {
      sopsFile = ../../secrets/ssl.yaml;
      owner = config.users.users.nginx.name;
    };
    secrets.SSL_CF_KEY = lib.mkIf mo.system.nginx.enable {
      sopsFile = ../../secrets/ssl.yaml;
      owner = config.users.users.nginx.name;
    };
  };
}
