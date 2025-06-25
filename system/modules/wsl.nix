{ opts, ... }:
{
  wsl.enable = opts.system.wsl;
  wsl.defaultUser = "${opts.username}";
  wsl.wslConf.interop.enabled = false;
  wsl.wslConf.interop.appendWindowsPath = false;
}
