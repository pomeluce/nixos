{ config, pkgs, ... }:
{
  imports = [ ../common.nix ];

  mo = {
    system = {
      wsl = false;
      bluetooth = true;
      mihomo = true;
      docker = true;
      postgres = true;

      # proxy
      proxy.enable = false;
      proxy.http = "";
      proxy.https = "";

      virt.enable = true;
      virt.kvm-cpu-type = "intel";
      virt.kvm-gpu-ids = [
        "10de:28e0" # Graphics
        "10de:22be" # Audio
      ];

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      gpu.kind = [ "intel-nvidia" ];
      gpu.intel-bus-id = "PCI:0:2:0";
      gpu.amd-bus-id = "";
      gpu.nvidia-bus-id = "PCI:1:0:0";

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

      wallpaper.enable = false;
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

      niri.opacity.active = "0.8";
      niri.opacity.inactive = "0.85";

      # GPU 直通场景: 让 niri 忽略 NVIDIA DRM 设备, 只用 Intel 核显,
      # 这样 VM 启动时可以无缝把 NVIDIA 切换给 vfio-pci (热切换).
      niri.debug = ''
        debug {
          ignore-drm-device "/dev/dri/by-path/pci-0000:01:00.0-card"
          ignore-drm-device "/dev/dri/by-path/pci-0000:01:00.0-render"
        }
      '';

      swaylock.font-size = 42;

      ssh.enableHost = true;
      ssh.hosts = {
        "github.com" = {
          HostName = "ssh.github.com";
          Port = 443;
          IdentityFile = "~/.ssh/id_github";
        };
        conevps = {
          HostName = config.sops.placeholder.VPS_CONE_IP;
          Port = config.sops.placeholder.VPS_CONE_PORT;
          IdentityFile = "~/.ssh/id_ssh";
        };
        rackvps = {
          HostName = config.sops.placeholder.VPS_RACK_IP;
          Port = config.sops.placeholder.VPS_RACK_PORT;
          IdentityFile = "~/.ssh/id_ssh";
        };
      };
    };

    userPackages = with pkgs; [
      telegram-desktop
      spotify
      reqable
      qbittorrent-enhanced
      qq
      wechat
      mossx
    ];
  };
}
