{ pkgs, ... }:
{
  apple-font = pkgs.callPackage ./apple-font { };
  rime-ice = pkgs.callPackage ./rime-ice { };
  scripts = import ./scripts pkgs;
}
