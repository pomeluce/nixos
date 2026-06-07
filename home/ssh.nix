{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "ConeCloud" = {
        Hostname = "182.255.80.201";
        Port = 2200;
        User = "marcus";
        IdentityFile = "~/.ssh/id_ssh";
      };
      "github.com" = {
        Hostname = "ssh.github.com";
        Port = 443;
        IdentityFile = "~/.ssh/id_github";
      };
    };
  };
}
