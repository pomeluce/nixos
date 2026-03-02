{ config, lib, ... }:
let
  mo = config.mo;
in
{
  config = lib.mkIf mo.desktop.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        # color-scheme = "prefer-dark";
        # cursor-size = mo.desktop.cursor.size;
        # cursor-theme = "${mo.desktop.cursor.theme}";
        # font-name = "PingFang SC 11";
        # gtk-theme = "WhiteSur-Dark";
        # icon-theme = "${mo.desktop.icon.theme}";
        # monospace-font-name = "Maple Mono Normal NL NF 10";
        text-scaling-factor = mo.desktop.scaling.gtk;
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,maximize,minimize,appmenu:";
      };
    };
  };
}
