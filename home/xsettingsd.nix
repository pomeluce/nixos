{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mo.desktop.enable {
    home.file.".config/xsettingsd/xsettingsd.conf".text = ''
      Gtk/CursorThemeName "${config.mo.desktop.cursor.theme}"
      Gtk/DecorationLayout "close,minimize,maximize,appmenu:"
      Net/IconThemeName "${config.mo.desktop.icon.theme}"
    '';

    home.packages = with pkgs; [
      xsettingsd
    ];
  };
}
