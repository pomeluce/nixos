{
  lib,
  config,
  # pkgs,
  ...
}:
{
  config = lib.mkIf (config.mo.desktop.enable && "ghostty" == config.mo.programs.terminal) {
    programs.ghostty = {
      enable = true;
      settings = {
        cursor-style = "block";
        cursor-style-blink = false;
        custom-shader = "${./cursor_smear.glsl}";
        gtk-toolbar-style = "flat";

        font-family = [
          "Maple Mono Normal NL NF"
          "CaskaydiaMono Nerd Font Mono"
          "PingFang SC"
          "Noto Sans CJK SC"
        ];
        font-size = 14;

        window-padding-x = 20;
        window-padding-y = "12,10";
        shell-integration-features = "no-cursor";

        keybind = [
          # copy/paste
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"

          # tabs
          "alt+t=new_tab"
          "alt+w=close_tab:this"
          "alt+[=previous_tab"
          "alt+]=next_tab"
          "alt+tab=next_tab"

          # splits
          "ctrl+alt+\=new_split:right"
          "ctrl+alt+/=new_split:down"
          "ctrl+alt+arrow_down=resize_split:down,12"
          "ctrl+alt+arrow_left=resize_split:left,12"
          "ctrl+alt+arrow_right=resize_split:right,12"
          "ctrl+alt+arrow_up=resize_split:up,12"
          "ctrl+shift+arrow_down=goto_split:down"
          "ctrl+shift+arrow_left=goto_split:left"
          "ctrl+shift+arrow_right=goto_split:right"
          "ctrl+shift+arrow_up=goto_split:up"

          # fonts
          "alt+arrow_up=increase_font_size:1"
          "alt+arrow_down=decrease_font_size:1"
          "alt+r=reset_font_size"

          # fullscrren
          "F11=toggle_fullscreen"

          # reload
          "ctrl+alt+s=reload_config"
        ];
      };
    };

    stylix.targets = {
      ghostty.enable = true;
      ghostty.fonts.enable = false;
    };
  };
}
