{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-size = 36;
      cursor-theme = "Bibata-Modern-Ice";
      font-name = "PingFang SC 11";
      gtk-theme = "WhiteSur-Dark";
      icon-theme = "MoreWaita";
      monospace-font-name = "CaskaydiaMono Nerd Font Mono 10";
      text-scaling-factor = 1.5;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,maximize,minimize,appmenu:";
    };
  };
}
