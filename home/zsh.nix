{
  inputs,
  pkgs,
  config,
  ...
}:
let
  zshDeps = with pkgs; [
    bat
    fd
    fzf
    eza
    # lsd
    git
    lua
    jq
  ];
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    initContent = ''
      source $HOME/.config/akir-zimfw/init.zsh
    '';
  };

  programs.lsd = {
    enable = true;
    settings = {
      date = "+%Y-%m-%d %H:%M:%S";
    };
  };

  home.file."akir-zimfw" = {
    target = "${config.home.homeDirectory}/.config/akir-zimfw";
    source = inputs.azimfw;
  };

  home.packages = zshDeps;
}
