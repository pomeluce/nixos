{ opts, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age = {
      generateKey = true;
      sshKeyPaths = [ "/home/${opts.username}/.ssh/id_sops" ];
      keyFile = "/etc/ssh/age/keys.txt";
    };
    secrets.MIHOMO_PROVIDER = { };
  };
}
