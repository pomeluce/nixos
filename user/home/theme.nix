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
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "${mo.desktop.cursor.theme}";
      size = mo.desktop.cursor.size;
      package = pkgs.bibata-cursors;
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile = {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=WhiteSurDark
      '';
      "Kvantum/WhiteSur".source = "${pkgs.whitesur-kde}/share/Kvantum/WhiteSur";
    };
  };
}
