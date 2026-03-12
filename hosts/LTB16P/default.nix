{ pkgs, ... }:
{
  imports = [ ../common.nix ];

  mo = {
    system = {
      bluetooth = true;
      docker = true;
      mihomo = true;
      postgres = true;
      wsl = false;

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ "intel-nvidia" ];
      drive.intel-bus-id = "PCI:0:2:0";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "PCI:1:0:0";

      # user env
      session-variables = {
        FILE_MANAGER = "nautilus";
        GSK_RENDERER = "ngl";
      };
    };

    desktop = {
      enable = true;
      scaling = {
        gtk = 1;
        qt = 1;
        xwayland = 1.5;
        sddm = 1.5;
      };

      wm.niri = true;
      wm.hyprland = false;
      dm.defaultSession = "niri";
      dm.sddm = true;

      colorscheme = "gruvbox-material-dark-hard";

      wallpaper.enable = true;
    };

    programs = {
      wezterm.font-size = 20;

      firefox.enable = true;
      steam.enable = true;
      keyd.enable = true;
      keyd.settings = {
        main = {
          # Maps capslock to escape when pressed and meta when held.
          capslock = "overload(meta, esc)";

          # Remaps the escape key to capslock
          esc = "capslock";
        };
      };

      niri.output = ''
        output "DP-1" {
          // 默认聚焦在这个显示器
          focus-at-startup
          mode "3840x2160@170"
          // 缩放
          scale 1.5
          // transform 允许逆时针旋转显示, 有效值为:
          // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
          transform "normal"
          // 输出在所有显示器坐标空间中的位置, 未明确配置位置的显示器将放置在所有已放置的显示器右侧
          // position x=4800 y=0
        }

        output "eDP-1" {
          // 默认聚焦在这个显示器
          focus-at-startup
          mode "3200x2000@165.001"
          // 缩放
          scale 1.5
          // transform 允许逆时针旋转显示, 有效值为:
          // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
          transform "normal"
          // 输出在所有显示器坐标空间中的位置, 未明确配置位置的显示器将放置在所有已放置的显示器右侧
          position x=0 y=0
        }
      '';
      niri.opacity.active = "1.0";
      niri.opacity.inactive = "1.0";

      swaylock.font-size = 42;
    };

    userPackages = with pkgs; [
      vscode
      telegram-desktop
      spotify
      reqable
      # vlc
      qbittorrent-enhanced
      # npkgs.wpsoffice
      # wpsoffice-cn
      qq
      # nur.repos.novel2430.wechat-universal-bwrap
    ];
  };
}
