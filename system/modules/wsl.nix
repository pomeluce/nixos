{ config, lib, ... }:
{
  config = lib.mkIf config.myOptions.system.wsl {
    wsl.enable = true;
    wsl.defaultUser = "${config.myOptions.username}";
    wsl.wslConf.interop.enabled = false;
    wsl.wslConf.interop.appendWindowsPath = false;
  };
}
