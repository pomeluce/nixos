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
    luajitPackages.luarocks
    luajitPackages.jsregexp
    python314Packages.pynvim
    translate-shell # translate.nvim required
    imagemagick # img-clip.nvim required
    kulala-core # kulala.nvim required

    # lsp
    bash-language-server
    clang-tools
    cmake-language-server
    copilot-language-server
    docker-language-server
    emmet-language-server
    jdt-language-server
    kotlin-language-server
    lemminx # xml lsp
    lua-language-server
    marksman # markdown
    nixd # nix
    rust-analyzer
    tailwindcss-language-server
    taplo # toml
    ty # python lsp
    typescript-language-server
    vscode-langservers-extracted
    vue-language-server

    # dap
    gdb
    vscode-extensions.ms-vscode.cpptools
    vscode-extensions.vadimcn.vscode-lldb.adapter
    vscode-extensions.vscjava.vscode-java-debug
    vscode-js-debug
    vscode-extensions.firefox-devtools.vscode-firefox-debug

    # fmt
    beautysh # shell: bash zsh
    cbfmt # markdown
    dockerfmt
    kulala-fmt # http
    libxml2 # xml
    nixfmt
    nufmt # nushell
    prettier
    prettierd
    ruff # python
    rustfmt
    shfmt # shell
    sqlfluff # sql
    stylua # lua
  ];
  nvimPath = "${config.mo.devspace}/repos/nvim";
in
{

  xdg.configFile."nvim/after".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/after";
  xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/lua";
  xdg.configFile."nvim/snippets".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/snippets";
  xdg.configFile."nvim/tmpls".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/tmpls";
  xdg.configFile."nvim/settings.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.mo.devspace}/repos/nixos/home/nvim/settings.toml";
  xdg.configFile."nvim/nvim-pack-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink "${nvimPath}/nvim-pack-lock.json";

  programs.neovim = {
    enable = true;
    extraPackages = nvimDeps;
    initLua = ''
      require('core.globals')
      require('core.options')
      require('core.autocmds')
      require('core.mappings')
      require('core.commands')
      require('core.setup')
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    VSC_CPPTOOLS_DEBUG = "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools";
    VSC_JAVA_DEBUG = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
    VSC_FIREFOX_DEBUG = "${pkgs.vscode-extensions.firefox-devtools.vscode-firefox-debug}/share/vscode/extensions/firefox-devtools.vscode-firefox-debug";
  };
}
