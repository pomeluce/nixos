{
  lib,
  opts,
  nlib,
  ...
}:
{
  home.file.".config/niri/config.kdl".text = ''
    input {
      keyboard {
        xkb {
            layout "us"
        }
        repeat-delay 150
        repeat-rate 50
      }

      touchpad {
        tap
        natural-scroll
        scroll-method "two-finger"
      }

      mouse {
        accel-speed 0.4
      }

      // niri 默认接管电源按钮的功能是 sleep, 禁用
    	disable-power-key-handling
    }

    // cmd: `niri msg outputs`
    ${opts.programs.niri.output}

    layout {
      // 窗口内部间隙
      gaps 20
      // 外部间隙
      struts {
        left 10
        right 10
        top 10
        bottom 10
      }
      center-focused-column "never"
      // 只有一个窗口时自动居中显示
      always-center-single-column

       // 在预设之间切换的宽度
      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
        proportion 0.75
        // 固定设置逻辑像素的宽度精确设置(受scale影响)
        // fixed 1920
      }
      // 默认窗口列宽度
      default-column-width { proportion 1.00; }

      // 聚焦框
      focus-ring {
        width ${toString (builtins.floor (2 * opts.system.gtk.scale))}
        // 聚焦窗口的边框颜色
        // - CSS named colors: "red"
        // - RGB hex: "#rgb", "#rgba", "#rrggbb", "#rrggbbaa"
        // - CSS-like notation: "rgb(255, 127, 0)", rgba(), hsl() and a few others.
        active-gradient from="#33ccffee" to="#00ff99ee" angle=45
      }
      // 关闭边框
      border {
        off
      }
    }

    // env
    environment {
      XMODIFIERS "@im=fcitx"
      QT_IM_MODULE "fcitx"
      SDL_IM_MODULE "fcitx"

      // 禁用 QT 应用程序上的窗口装饰
      QT_WAYLAND_DISABLE_WINDOWDECORATION "1"

      // 自动缩放 QT 程序
      QT_AUTO_SCREEN_SCALE_FACTOR "1"
      QT_ENABLE_HIGHDPI_SCALING "1"
      // 按照屏幕缩放比例设置 QT 程序的 DPI
      QT_SCREEN_SCALE_FACTORS "${nlib.utils.floatToString opts.system.qt.scale}"

      // wayland 运行 QT 和 GTK (wayland 不可用时使用 xcb<x11>)
      QT_QPA_PLATFORM "wayland;xcb"
      GDK_BACKEND "wayland,x11,*"
      // wayland 运行 clutter
      CLUTTER_BACKEND "wayland"

      // 语言环境
      LANG "zh_CN.UTF-8"
      LC_ALL "zh_CN.UTF-8"
      LANGUAGE "zh_CN.UTF-8"
    }

    cursor {
      xcursor-theme "${opts.system.cursor.theme}"
      xcursor-size ${toString opts.system.cursor.size}
    }


    // startup
    spawn-sh-at-startup "akirds"
    spawn-sh-at-startup "echo 'Xft.dpi: ${
      toString (builtins.floor (96 * opts.system.gtk.scale))
    }' | xrdb -merge"
    spawn-sh-at-startup "xsettingsd"
    spawn-sh-at-startup "wl-paste --watch cliphist store"
    ${if opts.system.wallpaper.enable then "spawn-sh-at-startup \"wallpaper-daemon\"" else ""}

    animations {
      workspace-switch {
        spring damping-ratio=0.75 stiffness=1000 epsilon=0.0001
      }
      window-open {
        duration-ms 300
        curve "cubic-bezier" 0.05 0.9 0.1 1.05
      }
      window-close {
        duration-ms 300
        curve "cubic-bezier" 0.05 0.9 0.1 1.05
      }
    }

    // window rules
    window-rule {
      match is-active=true
      opacity ${opts.programs.niri.opacity.active}
    }
    window-rule {
      match is-active=false
      opacity ${opts.programs.niri.opacity.inactive}
    }
    window-rule {
      geometry-corner-radius 15
      clip-to-geometry true
    }
    window-rule {
      match app-id=r#"firefox$"# title="^我的足迹$"
      open-floating true
    }
    window-rule {
      match app-id="jetbrains-idea" title="Plugin Installation"
      open-floating true
    }

    binds {
      Mod+B hotkey-overlay-title="Run a Browser: firefox" { spawn "firefox"; }
      Mod+E hotkey-overlay-title="Open a File Manager: nautilus" { spawn-sh "pkill nautilus; nautilus"; }
      Mod+R hotkey-overlay-title="Run an Application: akirds" { spawn-sh "akirds eval launcher app"; }
      Mod+V hotkey-overlay-title="Open Clipboard History: akirds" { spawn-sh "akirds eval launcher clipboard"; }
      Mod+D hotkey-overlay-title="Open Desktop Dock: akirds" { spawn-sh "akirds -t dock"; }
      Mod+F11 hotkey-overlay-title="Open PowerMenu Panel: akirds" { spawn-sh "akirds -t powermenu"; }
      Mod+Return hotkey-overlay-title="Open a Terminal: ghostty" { spawn "ghostty"; }
      Mod+Shift+R hotkey-overlay-title="Restart Desktop Shell: akirds" { spawn-sh "akirds -q; akirds"; }
      Mod+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn-sh "swaylock -eF"; }

      // 截屏和录屏
      Print { spawn "screenshot"; }
      Shift+Print { spawn-sh "screenshot --full"; }
      Mod+Print { spawn "screenrecord"; }
      Mod+Shift+Print { spawn-sh "screenrecord --full"; }

      // allow-when-locked=true 会在锁屏时也生效
      // 音量控制
      XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
      // 亮度控制
      XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

      // 开关 overview
      Mod+Tab repeat=false { toggle-overview; }
      // 关闭当前窗口
      Ctrl+Mod+Q repeat=false { close-window; }

      // 退出 niri 会话
      Mod+F12 { quit; }
      Ctrl+Alt+Delete { quit; }

      // 窗口切换
      Mod+Left  { focus-column-left; }
      Mod+H     { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+J     { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+K     { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+L     { focus-column-right; }
      Mod+Home  { focus-column-first; }
      Mod+End   { focus-column-last; }

      // 移动窗口
      Mod+Shift+Left  { move-column-left; }
      Mod+Shift+Down  { move-window-down; }
      Mod+Shift+Up    { move-window-up; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+H     { move-column-left; }
      Mod+Shift+J     { move-window-down; }
      Mod+Shift+K     { move-window-up; }
      Mod+Shift+L     { move-column-right; }
      Mod+Shift+Home  { move-column-to-first; }
      Mod+Shift+End   { move-column-to-last; }

      // 切换到其他显示器
      Mod+Ctrl+Left  { focus-monitor-left; }
      Mod+Ctrl+Down  { focus-monitor-down; }
      Mod+Ctrl+Up    { focus-monitor-up; }
      Mod+Ctrl+Right { focus-monitor-right; }
      Mod+Ctrl+H     { focus-monitor-left; }
      Mod+Ctrl+J     { focus-monitor-down; }
      Mod+Ctrl+K     { focus-monitor-up; }
      Mod+Ctrl+L     { focus-monitor-right; }

      // 移动窗口列到其他显示器
      Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

      // 切换下一个/上一个工作区
      Mod+Page_Down      { focus-workspace-down; }
      Mod+Page_Up        { focus-workspace-up; }
      Mod+U              { focus-workspace-down; }
      Mod+I              { focus-workspace-up; }
      Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
      Mod+Ctrl+U         { move-column-to-workspace-down; }
      Mod+Ctrl+I         { move-column-to-workspace-up; }

      // 切换当前工作区到下一个/上一个工作区
      Mod+Shift+Page_Down { move-workspace-down; }
      Mod+Shift+Page_Up   { move-workspace-up; }
      Mod+Shift+U         { move-workspace-down; }
      Mod+Shift+I         { move-workspace-up; }

      // 使用鼠标滚轮切换工作区和窗口列
      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

      Mod+WheelScrollRight      { focus-column-right; }
      Mod+WheelScrollLeft       { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft  { move-column-left; }

      Mod+Shift+WheelScrollDown      { focus-column-right; }
      Mod+Shift+WheelScrollUp        { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

      // 工作区切换
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      // 移动窗口列到指定工作区
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }

      // 切换工作区
      Mod+Shift+Tab { focus-workspace-previous; }

      // 切换右侧窗口到当前窗口列
      Mod+Comma  { consume-window-into-column; }
      // 切换当前窗口列的窗口弹出到新建列
      Mod+Period { expel-window-from-column; }
      // 切换窗口列宽预设
      Mod+T { switch-preset-column-width-back; }
      // 重置窗口高度
      Mod+Shift+T { reset-window-height; }
      // 最大化和全屏
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      // 居中窗口列
      Mod+C { center-column; }

      // 调整窗口列宽度
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      // 调整窗口高度
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }

      // 在浮动和平铺窗口间切换焦点
      Mod+Space { switch-focus-between-floating-and-tiling; }
      // 切换窗口浮动状态
      Mod+Shift+Space { toggle-window-floating; }

      // 针对虚拟机软件可能需要键盘控制权, allow-inhibiting=false 忽略当前快捷键本身
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

      // 关闭显示器, 鼠标移动或按键会打开
      Mod+Shift+P { power-off-monitors; }
    }

    overview {
      zoom 0.75
    }

    // 跳过热键弹出提示界面
    hotkey-overlay {
      skip-at-startup
    }

    // 忽略软件自带的装饰(例如标题栏)
    prefer-no-csd

    // 截图保存路径
    screenshot-path "~/pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

    // 禁用鼠标窗口左上角热键
    gestures {
      hot-corners {
        off
      }
    }
  '';

  home.activation.niri = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -snf $DEVROOT/wsp/wallpapers ~/.config/wallpapers
  '';
}
