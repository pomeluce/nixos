{ pkgs, npkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      gtk.scale = 1.5;
      qt.scale = 1.5;

      bluetooth = true;
      mihomo = true;
      postgres = true;
      docker = true;
      wsl = false;

      desktop.enable = true;
      wm.niri = true;
      wm.hyprland = false;
      # niri, hyprland-uwsm
      dm.defaultSession = "niri";
      sddm.enable = true;

      cursor.size = 36;
      cursor.theme = "Bibata-Modern-Ice";
      icon.theme = "MoreWaita";

      wallpaper.enable = true;
      wallpaper.dir = "/home/${username}/.config/wallpapers/";
      wallpaper.interval = 300;
      wallpaper.fps = 165;

      # user env
      session-variables = {
        FILE_MANAGER = "nautilus";
        GSK_RENDERER = "ngl";
      };
      session-path = [ ];

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ "intel-nvidia" ];
      drive.intel-bus-id = "PCI:0:2:0";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "PCI:1:0:0";

      # virtualisation
      virt.enable = false;
      virt.kvm-cpu-type = "intel"; # "intel" or "amd"
      virt.kvm-gpu-ids = [
        "10de:28e0" # Graphics
        "10de:22be" # Audio
      ];
    };

    programs = {
      docker.data-root = "${devroot}/env/docker/";
      docker.exec-opts = [ "native.cgroupdriver=systemd" ];
      docker.insecure-registries = [ ];
      docker.registry-mirrors = [ ];

      firefox.enable = true;

      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";

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
        output "eDP-1" {
          // 默认聚焦在这个显示器
          focus-at-startup
          mode "3200x2000@165.001"
          // 缩放
          scale 1
          // transform 允许逆时针旋转显示, 有效值为:
          // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
          transform "normal"
          // 输出在所有显示器坐标空间中的位置, 未明确配置位置的显示器将放置在所有已放置的显示器右侧
          // position x=0 y=0
        }
      '';
      niri.opacity.active = "0.95";
      niri.opacity.inactive = "0.90";

      postgres.port = 5432;
      postgres.pkg = pkgs.postgresql_17;
      postgres.jit = "off";
      postgres.listen_addresses = "*";
      postgres.upgrade.pkg = pkgs.postgresql;

      steam.enable = true;
      swaylock.font-size = 32;

      # ghostty, wezterm
      terminal = "ghostty";
      wezterm.font-size = 20;
    };

    # packages for this machine
    packages = with pkgs; [
      vscode
      telegram-desktop
      spotify
      reqable
      vlc
      qbittorrent-enhanced
      npkgs.wpsoffice
      qq
      nur.repos.novel2430.wechat-universal-bwrap
    ];
  };
}
