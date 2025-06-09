{ lib, pkgs, ... }:
{

  home.activation.link-wezterm-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf ~/.config/wezterm
    ln -sfn /wsp/dotfiles/wezterm ~/.config/wezterm
  '';
  home.packages = with pkgs; [
    wezterm
  ];
}
