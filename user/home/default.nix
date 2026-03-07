{
  lib,
  config,
  pkgs,
  secretsPath,
  ...
}:
let
  mo = config.mo;
  baseDeps = with pkgs; [
    fd
    bat
    ripgrep
  ];
  sops_secrets = toString secretsPath;
in
{

  imports = [
    ./direnv.nix
    ./fastfetch.nix
    ./git.nix
    ./maven
    ./node.nix
    ./nvim.nix
    ./zsh.nix

    # 桌面环境相关模块
    ./akirds
    ./dconf.nix
    ./fcitx5
    ./firefox.nix
    ./fonts.nix
    ./hypr.nix
    ./jetbrains.nix
    ./niri.nix
    ./stylix.nix
    ./swaylock.nix
    ./terminal
    ./theme.nix
    ./typora
    ./xsettingsd.nix
  ];

  home = {
    username = mo.username;
    homeDirectory = "/home/${mo.username}";
    packages = baseDeps ++ mo.userPackages;

    sessionVariables = lib.mkMerge [
      {
        BROWSER = "firefox";
        TERMINAL = mo.programs.terminal;

        DEEPSEEK_API_KEY = "$(sops exec-env ${sops_secrets} 'echo -e $DEEPSEEK_API_KEY')";
        SILICONFLOW_API_KEY = "$(sops exec-env ${sops_secrets} 'echo -e $SILICONFLOW_API_KEY')";
        ALIYUN_API_KEY = "$(sops exec-env ${sops_secrets} 'echo -e $ALIYUN_API_KEY')";
        OPENROUTER_API_KEY = "$(sops exec-env ${sops_secrets} 'echo -e $OPENROUTER_API_KEY')";
      }
      (lib.mkIf (mo.desktop.enable && (mo.desktop.wm.hyprland || mo.desktop.wm.niri)) {
        XDG_DATA_DIRS = lib.concatStringsSep ":" [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
          "$XDG_DATA_DIRS"

        ];
      })
      (mo.system.session-variables or { })
    ];

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "$GOBIN"
      "$PNPM_HOME"
    ]
    ++ mo.system.session-path;

    enableNixpkgsReleaseCheck = false;
  };

  xdg.configFile."gtk-3.0/bookmarks".text =
    let
      dev = mo.devroot;
    in
    ''
      file:/// root
      file://${dev}/wsp wsp
      file://${dev}/code code
      file://${dev}/env env 
      file://${dev}/wsp/wallpapers swp
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
  home.stateVersion = "25.11";
}
