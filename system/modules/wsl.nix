{ config, lib, ... }:
{
  config = lib.mkIf config.mo.system.wsl {
    wsl.enable = true;
    wsl.defaultUser = "${config.mo.username}";
    wsl.wslConf.interop.enabled = true;
    wsl.wslConf.interop.appendWindowsPath = false;
  };
}
