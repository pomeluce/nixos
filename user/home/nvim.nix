{
  pkgs,
  config,
  opts,
  ...
}:
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
    basedpyright
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
    ruff
    rustfmt
    shfmt
    sqlfluff
    stylua
  ];

  nvimPath = "${opts.devroot}/wsp/nvim";
in
{

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = nvimDeps;
}
