{ pkgs, ... }:
{
  home.packages = with pkgs; [ typora ];

  home.file.".config/Typora/themes/mdmdt.css" = {
    source = ./mdmdt.css;
  };
}
