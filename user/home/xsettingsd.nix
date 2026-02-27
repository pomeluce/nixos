{
  lib,
  sysConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf sysConfig.myOptions.desktop.enable {
    home.file.".config/xsettingsd/xsettingsd.conf".text = ''
      Gtk/CursorThemeName "${sysConfig.myOptions.desktop.cursor.theme}"
      Gtk/DecorationLayout "close,minimize,maximize,appmenu:"
      Net/IconThemeName "${sysConfig.myOptions.desktop.icon.theme}"
    '';

    home.packages = with pkgs; [
      xsettingsd
    ];
  };
}
