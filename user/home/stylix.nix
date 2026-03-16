{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.mo.desktop.enable {
    stylix = {
      enable = true;
      autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.mo.desktop.colorscheme}.yaml";
      polarity = "dark";
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
        bat.enable = true;
        btop.enable = true;
        ghostty.enable = true;
        ghostty.fonts.enable = false;
        gnome.enable = true;
        gtk.enable = true;
        neovim.enable = true;
        nixos-icons.enable = true;
        qt.enable = true;
      };
    };
  };
}
