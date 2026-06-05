{ pkgs, ... }:
{
  apple-font = pkgs.callPackage ./apple-font { };
  ccline = pkgs.callPackage ./ccline { };
  cli-proxy-api = pkgs.callPackage ./cli-proxy-api { };
  elegant-theme = pkgs.callPackage ./elegant-theme { };
  kulala-core = pkgs.callPackage ./kulala-core { };
  kulala-fmt = pkgs.callPackage ./kulala-fmt { kulala-core = pkgs.callPackage ./kulala-core { }; };
  perry = pkgs.callPackage ./perry { };
  rime-ice = pkgs.callPackage ./rime-ice { };
  scripts = import ./scripts pkgs;
  wpsoffice = pkgs.libsForQt5.callPackage ./wpsoffice { };
}
