{ config, pkgs, ... }:
let
  mo = config.mo;
in
{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    DEVROOT = mo.devroot;

    GRADLE_USER_HOME = "${mo.devroot}/var/gradle";

    PNPM_HOME = "${mo.devroot}/var/node/pnpm/bin";

    CARGO_HOME = "${mo.devroot}/var/rust/cargo";

    PYTHON = "${pkgs.python3}/python3";

    GOPATH = "${mo.devroot}/var/golib";
    GOBIN = "/home/${mo.username}/.cache/go-bin";

    SOPS_AGE_KEY_FILE = "/etc/ssh/age/keys.txt";
  };
}
