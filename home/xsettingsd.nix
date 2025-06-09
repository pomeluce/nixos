{ pkgs, ... }:
{
  home.file.".config/xsettingsd/xsettingsd.conf".text = ''
    Gtk/CursorThemeName "Bibata-Modern-Ice"
    Gtk/DecorationLayout "close,minimize,maximize,appmenu:"
    Net/IconThemeName "MoreWaita"
  '';

  home.packages = with pkgs; [
    xsettingsd
  ];
}
