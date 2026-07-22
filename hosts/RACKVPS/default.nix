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
  # NixOS (nixos-rebuild): 系统级安装所有 terminfo.
  # Home Manager (hm switch): 用户级安装 ghostty terminfo 到 ~/.terminfo.
  environment.enableAllTerminfo = lib.mkIf (config ? environment) true;
  home.file.".terminfo/x/xterm-ghostty".source = lib.mkIf (
    config ? home
  ) "${pkgs.ghostty}/share/terminfo/x/xterm-ghostty";

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
