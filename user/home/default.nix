{
  lib,
  config,
  pkgs,
  opts,
  ...
}:
let
  deps =
    with pkgs;
    [
      fd
      bat
      ripgrep
    ]
    ++ opts.packages;
  sops_secrets = "${opts.devroot}/wsp/nixos/secrets.yaml";
in
{

  imports = [
    ./fastfetch.nix
    ./git.nix
    ./maven
    ./node.nix
    ./nvim.nix
    ./zsh.nix
  ]
  ++ lib.optionals (opts.system.desktop.enable == true) [
    ./akirshell
    ./dconf.nix
    ./fcitx5.nix
    ./firefox.nix
    ./fonts.nix
    ./hypr.nix
    ./jetbrains.nix
    ./swaylock.nix
    ./theme.nix
    ./typora
    ./wezterm
    ./xsettingsd.nix
  ];

  home = {
    username = "${opts.username}";
    homeDirectory = "/home/${opts.username}";
    packages = deps;

    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "wezterm";

      DEEPSEEK_API_KEY = "$(sops exec-env ${sops_secrets} 'echo -e $DEEPSEEK_API_KEY')";
      DEEPSEEK_API_KEY_S = "$(sops exec-env ${sops_secrets} 'echo -e $DEEPSEEK_API_KEY_S')";
      DEEPSEEK_API_ALIYUN = "$(sops exec-env ${sops_secrets} 'echo -e $DEEPSEEK_API_ALIYUN')";
    }
    // opts.system.session-variables;

    sessionPath = [
      "/home/${opts.username}/.local/bin"
      "$GOBIN"
      "$PNPM_HOME"
    ]
    ++ opts.system.session-path;

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
      file://${home}/env env 
      file://${home}/wsp/wallpapers swp
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
