{ config, pkgs, ... }:
let
  mo = config.mo;
in
{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    DEVROOT = mo.devroot;

    GRADLE_USER_HOME = "${mo.devroot}/env/gradle";

    PNPM_HOME = "${mo.devroot}/env/node/pnpm/bin";

    CARGO_HOME = "${mo.devroot}/env/rust/cargo";

    PYTHON = "${pkgs.python3}/python3";

    GOPATH = "${mo.devroot}/env/golib";
    GOBIN = "/home/${mo.username}/.cache/go-bin";

    SOPS_AGE_KEY_FILE = "/etc/ssh/age/keys.txt";
  };
}
