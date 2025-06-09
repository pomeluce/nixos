{
  config,
  pkgs,
  opts,
  ...
}:
let
  homePkgs =
    with pkgs;
    [
      fd
      bat
      ripgrep
    ]
    ++ opts.packages;
in
{

  imports = [
    ./dconf.nix
    ./fcitx5.nix
    ./fonts.nix
    ./git.nix
    ./hypr.nix
    ./nvim.nix
    ./swaylock.nix
    ./wezterm.nix
    ./xsettingsd.nix
    ./zsh.nix
  ];

  home = {
    username = "${opts.username}";
    homeDirectory = "/home/${opts.username}";
    packages = homePkgs;

    sessionVariables = {
    } // opts.sessionVariables;

    sessionPath = [
      "/home/${opts.username}/.local/bin"
      "$GOBIN"
      "$PNPM_HOME"
    ] ++ opts.sessionPath;

    enableNixpkgsReleaseCheck = false;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    publicShare = "${config.home.homeDirectory}/Public";
    pictures = "${config.home.homeDirectory}/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11";
}
