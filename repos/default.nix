{ pkgs, ... }:
{
  rime-ice = pkgs.callPackage ./rime-ice { };
  apple-font = pkgs.callPackage ./apple-font { };
}
