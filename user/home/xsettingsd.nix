{ pkgs, opts, ... }:
{
  home.file.".config/xsettingsd/xsettingsd.conf".text = ''
    Gtk/CursorThemeName "${opts.system.cursor.theme}"
    Gtk/DecorationLayout "close,minimize,maximize,appmenu:"
    Net/IconThemeName "${opts.system.icon.theme}"
  '';

  home.packages = with pkgs; [
    xsettingsd
  ];
}
