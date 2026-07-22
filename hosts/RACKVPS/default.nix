{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../common.nix ];

  # 允许所有终端类型的 terminfo(如 xterm-ghostty),
  # 避免 SSH 登录时 "unknown terminal type" 错误.
  # NixOS: 系统级安装所有 terminfo.
  # Home Manager standalone: 用户级安装 ghostty terminfo 到 ~/.terminfo.
  config = lib.mkMerge [
    (lib.mkIf (config ? environment) {
      environment.enableAllTerminfo = true;
    })
    (lib.mkIf (config ? home) {
      home.file.".terminfo/x/xterm-ghostty".source = "${pkgs.ghostty}/share/terminfo/x/xterm-ghostty";
    })
  ];

  mo = {
    system = {
      bluetooth = false;
      docker = true;
      mihomo = false;
      postgres = true;
      wsl = false;

      boot.mode = "bios";
      boot.device = "/dev/vda";

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ ];
      drive.intel-bus-id = "";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "";
    };

    desktop = {
      enable = false;
      scaling = {
        gtk = 1;
        qt = 1;
        xwayland = 1;
        sddm = 1;
      };

      wm.niri = false;
      wm.hyprland = false;
      dm.defaultSession = "niri";
      dm.sddm = false;

      wallpaper.enable = false;
    };

    programs = {
      wezterm.font-size = 14;

      firefox.enable = false;
      steam.enable = false;
      keyd.enable = false;
      keyd.settings = { };

      niri.output = "";
      niri.opacity.active = "";
      niri.opacity.inactive = "";

      ssh.enableHost = false;
      ssh.enableKey = false;
    };
  };
}
