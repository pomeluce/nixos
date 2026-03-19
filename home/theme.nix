{
  config,
  lib,
  pkgs,
  ...
}:
let
  mo = config.mo;
in
{
  config = lib.mkIf mo.desktop.enable {
    # home.pointerCursor = {
    #   gtk.enable = true;
    #   x11.enable = true;
    #   name = "${mo.desktop.cursor.theme}";
    #   size = mo.desktop.cursor.size;
    #   package = pkgs.bibata-cursors;
    # };

    # qt = {
    #   enable = true;
    #   platformTheme.name = "qtct";
    #   style.name = "kvantum";
    # };
    #
    # xdg.configFile = {
    #   "Kvantum/kvantum.kvconfig".text = ''
    #     [General]
    #     theme=WhiteSurDark
    #   '';
    #   "Kvantum/WhiteSur".source = "${pkgs.whitesur-kde}/share/Kvantum/WhiteSur";
    # };
    stylix = {
      cursor = {
        package = pkgs.bibata-cursors;
        name = config.mo.desktop.cursor.theme;
        size = config.mo.desktop.cursor.size;
      };
      fonts = {
        serif.name = "Noto Serif CJK SC";
        serif.package = pkgs.noto-fonts-cjk-serif;
        sansSerif.name = "PingFang SC";
        sansSerif.package = pkgs.npkgs.apple-font.ttf-pingfang;
        monospace.name = "Maple Mono Normal NL NF";
        monospace.package = pkgs.maple-mono.NormalNL-NF-unhinted;
        emoji.name = "Noto Color Emoji";
        emoji.package = pkgs.noto-fonts-color-emoji;
      };
      icons = {
        enable = true;
        package = pkgs.morewaita-icon-theme.overrideAttrs (oldAttrs: {
          postInstall =
            (pkgs.lib.colorscheme.recolor config.lib.stylix.colors.withHashtag.toList)
            + (oldAttrs.postInstall or "");
        });
        dark = config.mo.desktop.icon.theme;
        light = config.mo.desktop.icon.theme;
      };
      targets = {
        gnome.enable = true;
        gtk.enable = true;
        nixos-icons.enable = true;
        qt.enable = true;
      };
    };
  };
}
