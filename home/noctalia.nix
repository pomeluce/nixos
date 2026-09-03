{ config, lib, ... }:
let
  mo = config.mo;
in
{
  config = lib.mkIf config.mo.desktop.enable {
    programs.noctalia = {
      enable = true;
      settings = {
        bar = {
          autoHideDelay = 500;
          autoShowDelay = 150;
          backgroundOpacity = 0.85;
          barType = "simple";
          capsuleColorKey = "none";
          capsuleOpacity = 1;
          contentPadding = 2;
          density = "comfortable";
          displayMode = "always_visible";
          enableExclusionZoneInset = true;
          fontScale = 1;
          frameRadius = 12;
          frameThickness = 8;
          hideOnOverview = false;
          marginHorizontal = 4;
          marginVertical = 4;
          middleClickAction = "none";
          middleClickCommand = "";
          middleClickFollowMouse = false;
          monitors = [ ];
          mouseWheelAction = "none";
          mouseWheelWrap = true;
          outerCorners = true;
          position = "top";
          reverseScroll = false;
          rightClickAction = "none";
          rightClickCommand = "";
          rightClickFollowMouse = true;
          screenOverrides = [ ];
          showCapsule = false;
          showOnWorkspaceSwitch = true;
          showOutline = false;
          useSeparateOpacity = false;
          widgetSpacing = 6;
          widgets = {
            background_opacity = 0.75;
            center = [ "group:g1" ];
            contact_shadow = true;
            end = [
              "group:g3"
              "group:g4"
              "group:g5"
              "group:g7"
              "group:g6"
            ];
            font_weight = 400;
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            scale = 0.9;
            start = [ "group:g2" ];
            thickness = 40;
            capsule_group = [
              {
                border = "";
                fill = "outline";
                id = "g1";
                members = [
                  "audio_visualizer"
                  "clock"
                  "media"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g2";
                members = [
                  "launcher"
                  "workspaces"
                  "taskbar"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g3";
                members = [ "tray" ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g4";
                members = [
                  "notifications"
                  "clipboard"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g5";
                members = [
                  "network"
                  "bluetooth"
                  "volume"
                  "brightness"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g6";
                members = [
                  "control-center"
                  "session"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g7";
                members = [ "battery" ];
                opacity = 0.6;
                padding = 14.0;
              }
            ];
          };
        };
        control_center = {
          sidebar = "full";
          sidebar_section = "full";
        };
        desktop_widgets = {
          enabled = false;
          schema_version = 2;
          widget_order = [ ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = { };
        };
        dock = {
          enabled = false;
        };
        location = {
          auto_locate = true;
        };
        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
        };
        osd = {
          background_opacity = 0.80;
          enabled = true;
          monitors = [ ];
          position = "top_right";
        };
        shell = {
          avatar_path = "/var/lib/AccountsService/icons/${mo.username}";
          font_family = "PingFang SC";
          settings_show_advanced = true;
          polkit_agent = true;
          launcher = {
            categories = false;
          };
          panel = {
            control_center_placement = "floating";
            control_center_position = "center";
            open_near_click_control_center = true;
            session_placement = "floating";
            session_position = "center";
            transparency_mode = "soft";
            wallpaper_placement = "floating";
            wallpaper_position = "center";
          };
          screen_corners = {
            enabled = true;
            size = 1;
          };
          screenshot = {
            save_to_file = false;
          };
        };
        theme = {
          source = "wallpaper";
          templates = {
            builtin_ids = [
              "btop"
              "gtk3"
              "gtk4"
              "ghostty"
              "niri"
              "qt"
            ];
            community_ids = [
              "pywalfox"
              "steam"
              "telegram"
            ];
          };
        };
        wallpaper = {
          directory = "${mo.desktop.wallpaper.dir}";
          edge_smoothness = 0.05;
          enabled = true;
          automation = {
            enabled = true;
            interval_seconds = 300;
            order = "alphabetical";
          };
        };
        weather = {
          enabled = false;
        };
        widget = {
          brightness = {
            actions = {
              scroll_up = "brightness-up 1%";
              scroll_down = "brightness-down 1%";
            };
            show_label = false;
          };
          clock = {
            format = "{:%m-%d %H:%M:%S - %A}";
          };
          launcher = {
            anchor = true;
            glyph = "rocket";
          };
          network = {
            show_label = false;
          };
          taskbar = {
            anchor = true;
            show_active_indicator = false;
          };
          volume = {
            actions = {
              scroll_up = "volume-up 1%";
              scroll_down = "volume-down 1%";
            };
            show_label = false;
          };
          workspaces = {
            show_labels = false;
          };
          media = {
            hide_when_no_media = true;
          };
        };
        keybinds = {
          down = [ "Ctrl+j" ];
          up = [ "Ctrl+k" ];
          left = [ "Shift+ISO_Left_Tab" ];
          right = [ "Tab" ];
        };
        lockscreen = {
          blurred_desktop = true;
        };
        backdrop = {
          enabled = true;
        };
      };
    };
  };
}
