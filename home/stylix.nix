{ pkgs, config, ... }:
{

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.mo.desktop.colorscheme}.yaml";
    polarity = "dark";
    targets = {
      bat.enable = true;
      btop.enable = true;
    };
  };
}
