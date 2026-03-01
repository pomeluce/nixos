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
    defaultSopsFile = ../../secrets.yaml;
    age = {
      generateKey = true;
      sshKeyPaths = [ "/home/${mo.username}/.ssh/id_sops" ];
      keyFile = "/etc/ssh/age/keys.txt";
    };
    secrets.ACCESS_TOKEN = {
      mode = "0400";
      owner = config.users.users."${mo.username}".name;
    };
    secrets.DEEPSEEK_API_KEY = { };
    secrets.DEEPSEEK_API_KEY_S = { };
    secrets.DEEPSEEK_API_ALIYUN = { };
    secrets.MIHOMO_PROVIDER = { };
    secrets.PG_INITIAL = lib.mkIf (mo.system.postgres == true) {
      mode = "0400";
      owner = config.users.users.postgres.name;
    };
  };
}
