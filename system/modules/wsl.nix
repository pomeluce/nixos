{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mo.system.wsl {
    wsl.enable = true;
    wsl.defaultUser = "${config.mo.username}";
    wsl.wslConf.interop.enabled = true;
    wsl.wslConf.interop.appendWindowsPath = false;
    wsl.wslConf.automount.options = "metadata";

    environment.systemPackages = [ pkgs.bubblewrap ];

    system.activationScripts.codexDesktopBash = lib.stringAfter [ "usrbinenv" ] ''
      mkdir -p /usr/bin
      chmod 0755 /usr/bin
      ln -sfn "${pkgs.bashInteractive}/bin/bash" /usr/bin/.bash.tmp
      mv -Tf /usr/bin/.bash.tmp /usr/bin/bash
    '';
  };
}
