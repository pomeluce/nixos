{ pkgs, config, ... }:
let
  nvimDeps = with pkgs; [
    bat
    fd
    fzf
    ripgrep
    silver-searcher
    tree-sitter
    unzip
    wl-clipboard
    luajitPackages.luarocks-nix
    python313Packages.pynvim

    # lsp
    bash-language-server
    clang-tools
    cmake-language-server
    vscode-langservers-extracted
    emmet-language-server
    kotlin-language-server
    lua-language-server
    marksman
    nil
    rust-analyzer
    tailwindcss-language-server
    taplo
    typescript-language-server
    vue-language-server

    # fmt
    beautysh
    nixfmt-rfc-style
    nodePackages.prettier
    rustfmt
    shfmt
    sqlfluff
    stylua
  ];

  akirNvim = pkgs.fetchFromGitHub {
    owner = "pomeluce";
    repo = "nvim";
    rev = "9242698831cc414f68591aee77391205d5964669";
    sha256 = "193axv0sljd56d3nimzncczlpnxx602qw4413rvl63g2xfa4g51l";
  };
in
{
  home.file."nvim" = {
    target = "${config.home.homeDirectory}/.config/nvim";
    source = akirNvim;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = nvimDeps;
}
