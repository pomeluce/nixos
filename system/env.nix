{ pkgs, opts, ... }:
{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    JAVA_HOME8 = "${pkgs.zulu8}/lib/openjdk";
    JAVA_HOME21 = "${pkgs.zulu}/lib/openjdk";
    JAVA_HOME = "${pkgs.zulu}/lib/openjdk";
    GRADLE_USER_HOME = "/env/gradle";

    PNPM_HOME = "/env/node/pnpm/bin";

    CARGO_HOME = "/env/rust/cargo";

    PYTHON = "${pkgs.python3}/python3";

    GOPATH = "/env/golib";
    GOBIN = "/home/${opts.username}/.cache/go-bin";
  };
}
