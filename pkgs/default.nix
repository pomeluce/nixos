{ pkgs, ... }:
{
  apple-font = pkgs.callPackage ./apple-font { };
  cli-proxy-api = pkgs.callPackage ./cli-proxy-api { };
  elegant-theme = pkgs.callPackage ./elegant-theme { };
  rime-ice = pkgs.callPackage ./rime-ice { };
  scripts = import ./scripts pkgs;
  wpsoffice = pkgs.libsForQt5.callPackage ./wpsoffice { };
}
