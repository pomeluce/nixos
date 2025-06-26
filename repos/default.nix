{ pkgs, ... }:
{
  rime-ice = pkgs.callPackage ./rime-ice { };
  ttf-pingfang = pkgs.callPackage ./ttf-pingfang { };
}
