{ lib, pkgs, ... }:
{

  home.activation.link-wezterm-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf ~/.config/wezterm
    ln -snf $DEVROOT/wsp/dotfiles/wezterm ~/.config/wezterm
  '';
  home.packages = with pkgs; [
    wezterm
  ];
}
