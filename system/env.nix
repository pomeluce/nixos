{ config, pkgs, ... }:
let
  cfg = config.myOptions;
in
{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    DEVROOT = cfg.devroot;

    GRADLE_USER_HOME = "${cfg.devroot}/env/gradle";

    PNPM_HOME = "${cfg.devroot}/env/node/pnpm/bin";

    CARGO_HOME = "${cfg.devroot}/env/rust/cargo";

    PYTHON = "${pkgs.python3}/python3";

    GOPATH = "${cfg.devroot}/env/golib";
    GOBIN = "/home/${cfg.username}/.cache/go-bin";

    SOPS_AGE_KEY_FILE = "/etc/ssh/age/keys.txt";
  };
}
