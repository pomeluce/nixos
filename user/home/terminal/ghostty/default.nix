{ pkgs, ... }:
{
  home.packages = with pkgs; [ ghostty ];
  home.file.".config/ghostty/cursor_smear.glsl".source = ./cursor_smear.glsl;
  home.file.".config/ghostty/config".text = ''
    # Run `ghostty +show-config --default --docs` to view a list of
    # all available config options and their default values.

    theme = Monokai Pro Spectrum
    cursor-style = block
    cursor-style-blink = false
    custom-shader = "~/.config/ghostty/cursor_smear.glsl"
    gtk-toolbar-style = flat

    font-family = ""
    font-family = "Maple Mono Normal NL NF"
    font-family = "CaskaydiaMono Nerd Font Mono"
    font-family = "PingFang SC"
    font-family = "Noto Sans CJK SC"
    font-size = 13

    window-padding-x = 20
    window-padding-y = 12,10

    shell-integration-features = no-cursor

    # copy/paste
    keybind = ctrl+shift+c=copy_to_clipboard
    keybind = ctrl+shift+v=paste_from_clipboard

    # tabs
    keybind = alt+t=new_tab
    keybind = alt+w=close_tab:this
    keybind = alt+[=previous_tab
    keybind = alt+]=next_tab
    keybind = alt+tab=next_tab

    # splits
    keybind = ctrl+alt+\=new_split:right
    keybind = ctrl+alt+/=new_split:down
    keybind = ctrl+alt+arrow_down=resize_split:down,12
    keybind = ctrl+alt+arrow_left=resize_split:left,12
    keybind = ctrl+alt+arrow_right=resize_split:right,12
    keybind = ctrl+alt+arrow_up=resize_split:up,12
    keybind = ctrl+shift+arrow_down=goto_split:down
    keybind = ctrl+shift+arrow_left=goto_split:left
    keybind = ctrl+shift+arrow_right=goto_split:right
    keybind = ctrl+shift+arrow_up=goto_split:up

    # fonts
    keybind = alt+arrow_up=increase_font_size:1
    keybind = alt+arrow_down=decrease_font_size:1
    keybind = alt+r=reset_font_size

    # fullscrren
    keybind =  F11=toggle_fullscreen

    # reload
    keybind = ctrl+alt+s=reload_config
  '';
}
