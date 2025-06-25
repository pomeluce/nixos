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
    rev = "a7a48353406fe9116df4bc30860fa5403543a3c6";
    sha256 = "0i8fsq3gl4bxqamynnvliqiwg3dvqcxxzhjkwdqr0qbllzw3j7sh";

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
