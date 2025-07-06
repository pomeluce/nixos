{
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
    lsd
    git
    lua
  ];

  azimfw = pkgs.fetchFromGitHub {
    owner = "pomeluce";
    repo = "akir-zimfw";
    rev = "ad6801b957ad4f325abf017089884755e804681a";
    sha256 = "0j7srd1119lzgcxr3g07q4vbss9x8s7hasgrvakjwr2nhnlgvb0i";

  };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    initContent = ''
      source $HOME/.config/akir-zimfw/init.zsh
    '';
  };

  home.file."akir-zimfw" = {
    target = "${config.home.homeDirectory}/.config/akir-zimfw";
    source = azimfw;
  };

  home.packages = zshDeps;
}
