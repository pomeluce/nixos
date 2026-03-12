{ config, pkgs, ... }:
let
  buildSettings = import ./settings.xml.nix;
in
{
  home.file.".m2/settings.xml" = {
    text = buildSettings { config = config; };
  };

  home.file.".m2/maven".source = "${pkgs.maven}/maven";
}
