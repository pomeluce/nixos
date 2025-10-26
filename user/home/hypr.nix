{
  lib,
  opts,
  nlib,
  ...
}:
let
  cursorName = opts.system.cursor.theme;
  cursorSize = opts.system.cursor.size;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    portalPackage = null;

    settings = {
      # 显示器配置
      monitor = [ "eDP-1,3200x2000@165,0x0,1" ];
      # 自动启动配置
      exec-once = [
        "akir-shell" # 状态栏
        "echo 'Xft.dpi: ${toString (builtins.floor (96 * opts.system.gtk.scale))}' | xrdb -merge" # 设置 xwayland 应用 dpi
        "xsettingsd"
        "wl-paste --watch cliphist store" # 剪切板
      ]
      ++ lib.optionals (opts.system.wallpaper.enable == true) [
        "wallpaper-daemon" # 壁纸
      ];

      env = [
        "XMODIFIERS,@im=fcitx"
        "QT_IM_MODULE,fcitx"
        "SDL_IM_MODULE,fcitx"

        # xdg
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"

        # 禁用 QT 应用程序上的窗口装饰
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"

        # 自动缩放 QT 程序
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_ENABLE_HIGHDPI_SCALING,1"
        # 按照屏幕缩放比例设置 QT 程序的 DPI
        "QT_SCREEN_SCALE_FACTORS,${nlib.utils.floatToString opts.system.qt.scale}"

        # wayland 运行 QT 和 GTK (wayland 不可用时使用 xcb<x11>)
        "QT_QPA_PLATFORM,wayland;xcb"
        "GDK_BACKEND,wayland,x11,*"
        # wayland 运行 clutter
        "CLUTTER_BACKEND,wayland"

        # 光标主题
        "HYPRCURSOR_THEME,${cursorName}"
        "HYPRCURSOR_SIZE,${toString cursorSize}"

        # 语言环境
        "LANG,zh_CN.UTF-8"
        "LC_ALL,zh_CN.UTF-8"
        "LANGUAGE,zh_CN.UTF-8"
      ];

      bind = [
        # Actions
        "SUPER, B, exec, firefox"
        "SUPER, E, exec, pkill nautilus; nautilus"
        "SUPER, Return, exec, wezterm-gui"
        "SUPER ALT, L, exec, swaylock -eF"

        "SUPER, F12, exit,"
        "SUPER, P, pseudo,"
        "CTRL SUPER, Q, killactive,"
        "CTRL SUPER, Space, togglefloating,"
        "CTRL SUPER, Space, centerwindow,"

        # Akir
        "SUPER, R, exec, akir-shell eval \"launcher('app')\""
        "SUPER, V, exec, akir-shell eval \"launcher('clipboard')\""
        "SUPER, C, exec, akir-shell eval \"launcher('cmd')\""
        "SUPER, F11, exec, akir-shell -t powermenu"
        "SUPER SHIFT, R, exec, akir-shell -q; akir-shell"
        ",Print, exec, screenshot"
        "SHIFT, Print, exec, screenshot --full"
        "SUPER, Print, exec, screenrecord"
        "SUPER SHIFT, Print, exec, screenrecord --full"

        # Audio control
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioNext, exec, playerctl next"

        # Move focus
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"
        "SUPER, Space, cyclenext"
        "SUPER SHIFT, Space, cyclenext, prev"
        # "SUPER SHIFT, J, togglesplit,"

        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Move / Resize
        "CTRL SUPER, L, resizeactive, 30 0"
        "CTRL SUPER, H, resizeactive, -30 0"
        "CTRL SUPER, K, resizeactive, 0 -20"
        "CTRL SUPER, J, resizeactive, 0 20"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"

        # Fullscreen
        "SUPER SHIFT, F, fullscreen"

        # Special workspace
        "SUPER, S, togglespecialworkspace, magic"
        "SUPER SHIFT, S, movetoworkspace, special:magic"

        # Scroll through workspaces
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "center,floating:true"
        "float,class:^(.*fcitx5-config-qt.*)$"
        "float,class:firefox,title:我的足迹"
        "opacity 0.85 override 0.85 override,class:^(.*jetbrains.*)$"
        "float,class:QQ,title:^(.*)$"
        "tile,class:QQ,title:QQ"
        "float,class:org.pulseaudio.pavucontrol"
        "float,class:blueman-manager"
        "size 40% 50%,class:blueman-manager"
        "float,class:nm-connection-editor"
        "float,class:steam,title:好友列表"
        "float,class:steam,title:Steam 设置"
        "noblur,title:^()$,class:^()$"
        "opacity 1 override 1 override,title:^()$,class:^()$"
      ];

      # 键盘与输入设备配置
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = 0.5;
        repeat_delay = 170;
        repeat_rate = 50;
      };

      general = {
        gaps_in = 5;
        gaps_out = 15;
        border_size = 3;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 15;
        active_opacity = 0.75;
        fullscreen_opacity = 0.85;
        inactive_opacity = 0.85;
        blur = {
          enabled = true;
          xray = true;
          size = 15;
          passes = 4;
          ignore_opacity = true;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = false;
      };

      gesture = [
        "3, horizontal, workspace, next"
      ];

      misc = {
        force_default_wallpaper = -1;
      };

      device = [
        {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        }
      ];
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };
    };
  };

  home.activation.hyprConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -snf $DEVROOT/wsp/wallpapers ~/.config/wallpapers
  '';
}
