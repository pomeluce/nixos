{ config, pkgs, ... }:
let
  mo = config.mo;
in
{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    DEVSPACE = mo.devspace;

    GRADLE_USER_HOME = "${mo.devspace}/var/gradle";

    PNPM_HOME = "${mo.devspace}/var/node/pnpm/bin";

    CARGO_HOME = "${mo.devspace}/var/rust/cargo";

    PYTHON = "${pkgs.python3}/python3";

    GOPATH = "${mo.devspace}/var/golib";
    GOBIN = "/home/${mo.username}/.cache/go-bin";

    SOPS_AGE_KEY_FILE = "/etc/ssh/age/keys.txt";
  };
}
