{ lib, config, ... }:
let
  mo = config.mo;
  devspace = mo.devspace;
in
{
  home.sessionVariables = {
    DEVSPACE = devspace;
    GRADLE_USER_HOME = "${devspace}/var/gradle";
    PNPM_HOME = "${devspace}/var/node/pnpm/bin";
    CARGO_HOME = "${devspace}/var/rust/cargo";
    GOPATH = "${devspace}/var/golib";
    GOBIN = "${config.home.homeDirectory}/.cache/go-bin";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    config.home.sessionVariables.GOBIN
    config.home.sessionVariables.PNPM_HOME
  ]
  ++ mo.system.session-path;

  home.activation = {
    # 创建 devspace 二级目录
    ensureDevspace = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -euo pipefail
      mkdir -p \
        "${devspace}" \
        "${devspace}/code" \
        "${devspace}/database" \
        "${devspace}/database/sql" \
        "${devspace}/database/schemas" \
        "${devspace}/database/dumps" \
        "${devspace}/database/diagrams" \
        "${devspace}/database/clients" \
        "${devspace}/infra" \
        "${devspace}/repos" \
        "${devspace}/var" \
        "${devspace}/var/gradle" \
        "${devspace}/var/golib" \
        "${devspace}/var/maven" \
        "${devspace}/var/node" \
        "${devspace}/var/rust" \
        "${devspace}/work"
    '';
  };
}
