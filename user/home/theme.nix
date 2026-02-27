{
  sysConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = sysConfig.myOptions;
in
{
  config = lib.mkIf cfg.desktop.enable {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "${cfg.desktop.cursor.theme}";
      size = cfg.desktop.cursor.size;
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
