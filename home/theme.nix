{
  config,
  lib,
  pkgs,
  ...
}:
let
  mo = config.mo;
in
{
  config = lib.mkIf mo.desktop.enable {
    home.packages = with pkgs; [
      adw-gtk3
      adwaita-icon-theme
      morewaita-icon-theme
      bibata-cursors
      kdePackages.qt6ct
    ];

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "${mo.desktop.cursor.theme}";
      size = mo.desktop.cursor.size;
      package = pkgs.bibata-cursors;
    };

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
      # style.name = "noctalia";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-size = mo.desktop.cursor.size;
        cursor-theme = "${mo.desktop.cursor.theme}";
        font-name = "PingFang SC 11";
        gtk-theme = "adw-gtk3";
        icon-theme = "${mo.desktop.icon.theme}";
        monospace-font-name = "Maple Mono Normal NL NF 10";
        text-scaling-factor = mo.desktop.scaling.gtk;
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,maximize,minimize,appmenu:";
      };
    };
  };
}
