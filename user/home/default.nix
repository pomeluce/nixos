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
    ./wezterm
    ./xsettingsd.nix
    ./zsh.nix
  ];

  home = {
    username = "${opts.username}";
    homeDirectory = "/home/${opts.username}";
    packages = homePkgs;

    sessionVariables = {
    } // opts.system.session-variables;

    sessionPath = [
      "/home/${opts.username}/.local/bin"
      "$GOBIN"
      "$PNPM_HOME"
    ] ++ opts.system.session-path;

    enableNixpkgsReleaseCheck = false;
  };

  xdg.configFile."gtk-3.0/bookmarks".text =
    let
      home = opts.devroot;
    in
    ''
      file:/// root
      file://${home}/wsp wsp
      file://${home}/code code
      file://${home}/wsp/wallpapers wallpapers
    '';

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    publicShare = "${config.home.homeDirectory}/public";
    pictures = "${config.home.homeDirectory}/pictures";
    templates = "${config.home.homeDirectory}/templates";
    videos = "${config.home.homeDirectory}/videos";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05";
}
