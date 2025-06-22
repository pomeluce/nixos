{ pkgs, opts, ... }:
let
  zshDeps = with pkgs; [
    bat
    fd
    fzf
    eza
    lsd
    git
    lua
  ];
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    initContent = ''
      source ${opts.devroot}/wsp/akir-zimfw/init.zsh
    '';
  };

  home.packages = zshDeps;
}
