{ sysConfig, lib, ... }:
let
  cfg = sysConfig.myOptions;
in
{
  config = lib.mkIf cfg.desktop.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-size = cfg.desktop.cursor.size;
        cursor-theme = "${cfg.desktop.cursor.theme}";
        font-name = "PingFang SC 11";
        gtk-theme = "WhiteSur-Dark";
        icon-theme = "${cfg.desktop.icon.theme}";
        monospace-font-name = "Maple Mono Normal NL NF 10";
        text-scaling-factor = cfg.desktop.scaling.gtk;
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,maximize,minimize,appmenu:";
      };
    };
  };
}
