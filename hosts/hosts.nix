[
  {
    host = "LTB16P";
    extraOSModules = [ ./LTB16P/hardware-configuration.nix ];
  }
  {
    host = "LTPT14P";
    extraOSModules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ];
  }
  {
    host = "RACKVPS";
    extraOSModules = [
      ./RACKVPS/hardware-configuration.nix
      {
        # 安装所有终端 terminfo 条目(如 xterm-ghostty),
        # 避免 SSH 登录时 "unknown terminal type" 错误.
        # 放在 extraOSModules 中确保只对 NixOS 生效, Home Manager 不可见.
        environment.enableAllTerminfo = true;
      }
    ];
  }
]
