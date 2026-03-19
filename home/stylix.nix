{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.mo.desktop.colorscheme}.yaml";
    polarity = "dark";
    override = {
      base00 = "2b2b2b";
      base01 = "383838";
      base02 = "3d3d3d";
      base03 = "424242";
      base04 = "999999";
      base05 = "b3b3b3";
      base06 = "cccccc";
      base07 = "e0e0e0";
      base08 = "f07173";
      base09 = "e69875";
      base0A = "e2ae6a";
      base0B = "99c983";
      base0C = "60a673";
      base0D = "78bdb4";
      base0E = "d87595";
      base0F = "9d94d4";
    };
    targets = {
      bat.enable = true;
      btop.enable = true;
    };
  };
}
