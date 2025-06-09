{ pkgs, lib, ... }:
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
    nodePackages.vscode-json-languageserver
    # fmt
    beautysh
    nixfmt-rfc-style
    nodePackages.prettier
    rustfmt
    shfmt
    sqlfluff
    stylua
  ];
in
{
  home.activation.link-nvim-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf ~/.config/nvim
    ln -sfn $DEVROOT/wsp/nvim ~/.config/nvim
  '';
  xdg = {

    desktopEntries."nvim" = {
      name = "NeoVim";
      comment = "Text Editor";
      icon = "nvim";
      exec = "${pkgs.neovim}/bin/nvim %F";
      categories = [
        "Utility"
        "TextEditor"
      ];
      terminal = true;
      mimeType = [
        "text/plain"
        "text/english"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = nvimDeps;
}
