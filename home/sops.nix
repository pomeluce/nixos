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
    secrets.ID_GITHUB = { };
    secrets.ID_GITHUB_PUB = { };
    secrets.ID_SOPS = { };
    secrets.ID_SOPS_PUB = { };
    secrets.ID_SSH = { };
    secrets.ID_SSH_PUB = { };

    secrets.CPA_API_KEY = { };
    secrets.DEEPSEEK_API_KEY = { };
    secrets.FAVOR_API_KEY = { };
    secrets.OPENROUTER_API_KEY = { };
    secrets.ZAI_API_KEY = { };

    secrets.VPS_CONE_IP = { };
    secrets.VPS_CONE_PORT = { };
    secrets.VPS_RECK_IP = { };
    secrets.VPS_RECK_PORT = { };
  };
}
