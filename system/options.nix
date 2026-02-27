{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.mkOptions;
in
{
  options.myOptions = {
    # --- basic user info ---
    username = mkOption {
      type = types.str;
      default = "Tso";
    };
    uid = mkOption {
      type = types.int;
      default = 1000;
    };
    gid = mkOption {
      type = types.int;
      default = 1000;
    };
    devroot = mkOption {
      type = types.str;
      default = "/home/${cfg.username}/devroot";
    };

    # --- system service switch ---
    system = {
      bluetooth = mkEnableOption "Bluetooth Support";
      docker = mkEnableOption "Docker Support";
      mihomo = mkEnableOption "Mihomo Service";
      postgres = mkEnableOption "PostgreSQL Support";
      wsl = mkEnableOption "WSL Mode";

      # proxy setting
      proxy = {
        enable = mkEnableOption "System Proxy";
        http = mkOption {
          type = types.str;
          default = "";
        };
        https = mkOption {
          type = types.str;
          default = "";
        };
      };

      # hardware driver(GPU)
      drive = {
        gpu-type = mkOption {
          type = types.listOf (
            types.enum [
              "intel"
              "amd"
              "nvidia"
              "intel-nvidia"
              "amd-nvidia"
            ]
          );
          default = [ "intel" ];
        };
        intel-bus-id = mkOption {
          type = types.str;
          default = "";
        };
        amd-bus-id = mkOption {
          type = types.str;
          default = "";
        };
        nvidia-bus-id = mkOption {
          type = types.str;
          default = "";
        };
      };

      # virtualization
      virt = {
        enable = mkEnableOption "Virtualization";
        kvm-cpu-type = mkOption {
          type = types.enum [
            "intel"
            "amd"
          ];
          default = "intel";
        };
        kvm-gpu-ids = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };

      # environment variables
      session-variables = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };
      session-path = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };

    # --- desktop environment and display ---
    desktop = {
      enable = mkEnableOption "Desktop Environment";
      # scaling factor
      scaling = {
        gtk = mkOption {
          type = types.number;
          default = 1;
        };
        qt = mkOption {
          type = types.number;
          default = 1;
        };
        xwayland = mkOption {
          type = types.number;
          default = 1;
        };
        sddm = mkOption {
          type = types.number;
          default = 1;
        };
      };
      # window manager
      wm = {
        niri = mkEnableOption "Niri WM";
        hyprland = mkEnableOption "Hyprland WM";
      };
      dm = {
        defaultSession = mkOption {
          type = types.str;
          default = "niri";
        };
        sddm = mkEnableOption "SDDM";
      };
      # appearance
      cursor = {
        size = mkOption {
          type = types.int;
          default = 24;
        };
        theme = mkOption {
          type = types.str;
          default = "Bibata-Modern-Ice";
        };
      };
      icon.theme = mkOption {
        type = types.str;
        default = "MoreWaita";
      };
      wallpaper = {
        enable = mkEnableOption "Wallpaper Engine";
        dir = mkOption {
          type = types.str;
          default = "/home/${cfg.username}/.config/wallpapers";
        };
        interval = mkOption {
          type = types.int;
          default = 300;
        };
        fps = mkOption {
          type = types.int;
          default = 60;
        };
      };
    };

    # --- advanced configuration of specific programs ---
    programs = {
      terminal = mkOption {
        type = types.enum [
          "ghostty"
          "wezterm"
          "alacritty"
        ];
        default = "ghostty";
      };
      wezterm.font-size = mkOption {
        type = types.int;
        default = 12;
      };

      firefox.enable = mkEnableOption "Firefox";
      steam.enable = mkEnableOption "Steam";
      keyd = {
        enable = mkEnableOption "Keyd";
        settings = mkOption {
          type = types.attrs;
          default = { };
        };
      };

      git = {
        name = mkOption { type = types.str; };
        email = mkOption { type = types.str; };
        branch = mkOption {
          type = types.str;
          default = "main";
        };
      };

      docker = {
        data-root = mkOption { type = types.str; };
        exec-opts = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        insecure-registries = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        registry-mirrors = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };

      niri = {
        output = mkOption {
          type = types.lines;
          default = "";
        };
        opacity = {
          active = mkOption {
            type = types.str;
            default = "1.0";
          };
          inactive = mkOption {
            type = types.str;
            default = "1.0";
          };
        };
      };

      postgres = {
        pkg = mkOption {
          type = types.package;
          default = pkgs.postgresql;
        };
        upgrade_pkg = mkOption {
          type = types.package;
          default = pkgs.postgresql;
        };
        port = mkOption {
          type = types.int;
          default = 5432;
        };
        jit = mkOption {
          type = types.str;
          default = "off";
        };
        listen_addresses = mkOption {
          type = types.str;
          default = "*";
        };
      };

      swaylock.font-size = mkOption {
        type = types.int;
        default = 42;
      };
    };

    # --- machine specific package list ---
    userPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
  };
}
