{ pkgs, ... }:
{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    PYTHON = "${pkgs.python3}/python3";

    SOPS_AGE_KEY_FILE = "/etc/ssh/age/keys.txt";
  };
}
