{ config, lib, ... }:
{
  config = lib.mkIf config.mo.system.wsl {
    wsl.enable = true;
    wsl.defaultUser = "${config.mo.username}";
    wsl.wslConf.interop.enabled = false;
    wsl.wslConf.interop.appendWindowsPath = false;
  };
}
