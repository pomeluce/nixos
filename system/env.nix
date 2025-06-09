{ pkgs, opts, ... }: {
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    DEVROOT = opts.devroot;

    JAVA_HOME8 = "${pkgs.zulu8}/lib/openjdk";
    JAVA_HOME21 = "${pkgs.zulu}/lib/openjdk";
    JAVA_HOME = "${pkgs.zulu}/lib/openjdk";
    GRADLE_USER_HOME = "${opts.devroot}/env/gradle";

    PNPM_HOME = "${opts.devroot}/env/node/pnpm/bin";

    CARGO_HOME = "${opts.devroot}/env/rust/cargo";

    PYTHON = "${pkgs.python3}/python3";

    GOPATH = "${opts.devroot}/env/golib";
    GOBIN = "/home/${opts.username}/.cache/go-bin";
  };
}
