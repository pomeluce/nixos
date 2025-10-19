{ opts, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-size = opts.system.cursor.size;
      cursor-theme = "${opts.system.cursor.theme}";
      font-name = "PingFang SC 11";
      gtk-theme = "WhiteSur-Dark";
      icon-theme = "${opts.system.icon.theme}";
      monospace-font-name = "Maple Mono Normal NL NF 10";
      text-scaling-factor = opts.system.gtk.scale;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,maximize,minimize,appmenu:";
    };
  };
}
