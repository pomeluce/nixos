{
  config,
  lib,
  opts,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age = {
      generateKey = true;
      sshKeyPaths = [ "/home/${opts.username}/.ssh/id_sops" ];
      keyFile = "/etc/ssh/age/keys.txt";
    };
    secrets.ACCESS_TOKEN = { };
    secrets.MIHOMO_PROVIDER = { };
    secrets.PG_INITIAL = lib.mkIf (opts.system.postgres == true) {
      mode = "0400";
      owner = config.users.users.postgres.name;
    };
  };
}
