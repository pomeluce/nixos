{
  lib,
  config,
  pkgs,
  ...
}:
let
  mo = config.mo;
in
{
  home.activation = {
    # 创建 ~/shared 目录, 供 VM 通过 VirtIO-FS 映射共享文件(见 docs/kvm.md)
    ensureShared = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -euo pipefail
      mkdir -p "${config.home.homeDirectory}/shared"
      echo "ensureShared: ${config.home.homeDirectory}/shared created"
    '';

    # 双向写权限: VM 经 virtiofsd(root) 创建的文件默认属主 root、$USER 改不动.
    # 给目录设 default ACL, 让之后新建的文件自动继承 $USER 的 rwx.
    # setfacl 改自己拥有的目录不需要 root, 整个方案在用户态完成.详见 docs/kvm.md
    ensureSharedAcl = lib.hm.dag.entryAfter [ "ensureShared" ] ''
      set -euo pipefail
      ${pkgs.acl}/bin/setfacl -m u:${mo.username}:rwx "${config.home.homeDirectory}/shared"
      ${pkgs.acl}/bin/setfacl -d -m u:${mo.username}:rwx "${config.home.homeDirectory}/shared"
    '';
  };
}
