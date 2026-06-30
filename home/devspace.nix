{ lib, config, ... }:
let
  mo = config.mo;
  devspace = mo.devspace;
in
{
  home.activation = {
    # 创建 devspace 二级目录
    ensureDevspace = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -euo pipefail
      mkdir -p \
        "${devspace}" \
        "${devspace}/code" \
        "${devspace}/infra" \
        "${devspace}/repos" \
        "${devspace}/var" \
        "${devspace}/var/gradle" \
        "${devspace}/var/golib" \
        "${devspace}/var/maven" \
        "${devspace}/var/node" \
        "${devspace}/var/rust" \
        "${devspace}/var/agent" \
        "${devspace}/work"
      echo "ensureDevspace: directories created under ${devspace}"
    '';
  };
}
