{
  lib,
  config,
  pkgs,
  ...
}:
let
  mo = config.mo;
in
{

  imports = [
    ./claude
    # ./cpa
    ./direnv.nix
    ./fastfetch.nix
    ./git.nix
    ./maven
    ./node.nix
    ./nvim.nix
    ./sops.nix
    ./ssh.nix
    ./uv.nix
    ./zsh.nix

    # 桌面环境相关模块
    # ./akirds
    ./devspace.nix
    ./fcitx5
    ./firefox.nix
    ./fonts.nix
    ./hypr.nix
    ./jetbrains
    ./niri.nix
    ./noctalia.nix
    # ./swaylock.nix
    ./terminal
    ./theme.nix
    # ./vscode.nix
    ./typora
    ./xsettingsd.nix
  ];

  home = {
    username = mo.username;
    homeDirectory = "/home/${mo.username}";
    packages = mo.userPackages;

    sessionVariables = lib.mkMerge [
      {
        BROWSER = "firefox";
        TERMINAL = mo.programs.terminal;

        # locale
        LANG = "zh_CN.UTF-8";
        LC_ALL = "zh_CN.UTF-8";
        LANGUAGE = "zh_CN.UTF-8";

        # 使用 sops-nix 解密后的 secrets 路径
        CPA_API_KEY = "$(cat ${config.sops.secrets.CPA_API_KEY.path})";
        DEEPSEEK_API_KEY = "$(cat ${config.sops.secrets.DEEPSEEK_API_KEY.path})";
        OPENROUTER_API_KEY = "$(cat ${config.sops.secrets.OPENROUTER_API_KEY.path})";
        ZAI_API_KEY = "$(cat ${config.sops.secrets.ZAI_API_KEY.path})";

        # provided to claude code
        CLAUDE_API_KEY = "$(cat ${config.sops.secrets.DEEPSEEK_API_KEY.path})";
        CLAUDE_API_URL = "https://api.deepseek.com/anthropic";
        CLAUDE_MODEL_NAME = "deepseek-v4-pro[1m]";
      }
      (lib.mkIf (mo.desktop.enable && (mo.desktop.wm.hyprland || mo.desktop.wm.niri)) {
        # input method: fcitx
        XMODIFIERS = "@im=fcitx";
        QT_IM_MODULE = "fcitx";
        SDL_IM_MODULE = "fcitx";

        # wayland 运行 QT 和 GTK (wayland 不可用时使用 xcb<x11>)
        QT_QPA_PLATFORM = "wayland;xcb";
        GDK_BACKEND = "wayland,x11,*";
        # wayland 运行 clutter
        CLUTTER_BACKEND = "wayland";
        # 禁用 QT 应用程序上的窗口装饰
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        # 自动缩放 QT 程序
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_ENABLE_HIGHDPI_SCALING = "1";
        # 按照屏幕缩放比例设置 QT 程序的 DPI
        QT_SCREEN_SCALE_FACTORS = pkgs.lib.utils.floatToString mo.desktop.scaling.qt;

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
      dev = mo.devspace;
    in
    ''
      file:/// root
      file://${dev}/repos repos
      file://${dev}/code code
      file://${dev}/var var
      file://${dev}/repos/wallpapers swp
    '';

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    publicShare = "${config.home.homeDirectory}/public";
    pictures = "${config.home.homeDirectory}/pictures";
    templates = "${config.home.homeDirectory}/template";
    videos = "${config.home.homeDirectory}/videos";
    projects = null;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.11";
}
