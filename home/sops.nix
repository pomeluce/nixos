{ config, ... }:
let
  mo = config.mo;
in
{
  sops = {
    defaultSopsFile = ../secrets.yaml;
    age = {
      generateKey = true;
      sshKeyPaths = [ "/home/${mo.username}/.ssh/id_sops" ];
      keyFile = "/etc/ssh/age/keys.txt";
    };
    secrets.ALIYUNCS_API_KEY = { };
    secrets.OPENROUTER_API_KEY = { };
  };
}

