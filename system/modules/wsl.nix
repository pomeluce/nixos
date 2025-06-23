{ opts, ... }:
{
  wsl.enable = opts.system.wm.wsl;
  wsl.defaultUser = "${opts.username}";
}
