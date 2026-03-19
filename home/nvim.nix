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
    translate-shell
    imagemagick

    # lsp
    basedpyright
    bash-language-server
    clang-tools
    cmake-language-server
    copilot-language-server
    docker-language-server
    emmet-language-server
    kotlin-language-server
    lua-language-server
    marksman
    nil
    nixd
    rust-analyzer
    tailwindcss-language-server
    taplo
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
    beautysh
    cbfmt
    dockerfmt
    nixfmt
    nufmt
    prettier
    prettierd
    ruff
    rustfmt
    shfmt
    sqlfluff
    stylua
  ];

  nvimPath = "${config.mo.devroot}/wsp/nvim";
in
{

  xdg.configFile."nvim/after".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/after";
  xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/lua";
  xdg.configFile."nvim/snippets".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/snippets";
  xdg.configFile."nvim/tmpls".source = config.lib.file.mkOutOfStoreSymlink "${nvimPath}/tmpls";
  xdg.configFile."nvim/nvim-pack-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink "${nvimPath}/nvim-pack-lock.json";

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
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

  stylix.targets = {
    neovim.enable = true;
    neovim.transparentBackground.main = true;
    neovim.transparentBackground.numberLine = true;
    neovim.transparentBackground.signColumn = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    VSC_CPPTOOLS_DEBUG = "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools";
    VSC_JAVA_DEBUG = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
    VSC_FIREFOX_DEBUG = "${pkgs.vscode-extensions.firefox-devtools.vscode-firefox-debug}/share/vscode/extensions/firefox-devtools.vscode-firefox-debug";
  };
}
