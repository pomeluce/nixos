{ pkgs, ... }:
{
  apple-font = pkgs.callPackage ./apple-font { };
  elegant-theme = pkgs.callPackage ./elegant-theme { };
  rime-ice = pkgs.callPackage ./rime-ice { };
  scripts = import ./scripts pkgs;
}
