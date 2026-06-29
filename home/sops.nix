{ ... }:
{
  sops = {
    defaultSopsFile = ../secrets/home.yaml;
    age = {
      generateKey = true;
      # sshKeyPaths = [ "/home/${mo.username}/.ssh/id_sops" ];
      keyFile = "/etc/ssh/age/keys.txt";
    };
    secrets.ID_GITHUB.sopsFile = ../secrets/ssh.yaml;
    secrets.ID_GITHUB_PUB.sopsFile = ../secrets/ssh.yaml;
    secrets.ID_SOPS.sopsFile = ../secrets/ssh.yaml;
    secrets.ID_SOPS_PUB.sopsFile = ../secrets/ssh.yaml;
    secrets.ID_SSH.sopsFile = ../secrets/ssh.yaml;
    secrets.ID_SSH_PUB.sopsFile = ../secrets/ssh.yaml;

    secrets.CPA_API_KEY.sopsFile = ../secrets/ai.yaml;
    secrets.DEEPSEEK_API_KEY.sopsFile = ../secrets/ai.yaml;
    secrets.FAVOR_API_KEY.sopsFile = ../secrets/ai.yaml;
    secrets.OPENROUTER_API_KEY.sopsFile = ../secrets/ai.yaml;
    secrets.ZAI_API_KEY.sopsFile = ../secrets/ai.yaml;

    secrets.VPS_CONE_IP.sopsFile = ../secrets/vps.yaml;
    secrets.VPS_CONE_PORT.sopsFile = ../secrets/vps.yaml;
    secrets.VPS_RACK_IP.sopsFile = ../secrets/vps.yaml;
    secrets.VPS_RACK_PORT.sopsFile = ../secrets/vps.yaml;
  };
}
