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
    luajitPackages.luarocks
    python314Packages.pynvim
    translate-shell
    imagemagick

    # lsp
    basedpyright
    bash-language-server
    clang-tools
    cmake-language-server
    copilot-language-server
    emmet-language-server
    kotlin-language-server
    lua-language-server
    marksman
    nil
    rust-analyzer
    tailwindcss-language-server
    taplo
    typescript-language-server
    vscode-langservers-extracted
    vue-language-server

    # fmt
    beautysh
    cbfmt
    nixfmt
    prettier
    prettierd
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
