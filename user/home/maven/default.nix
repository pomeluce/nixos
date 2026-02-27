{ sysConfig, pkgs, ... }:
let
  buildSettings = import ./settings.xml.nix;
in
{
  home.file.".m2/settings.xml" = {
    text = buildSettings { sysConfig = sysConfig; };
  };

  home.file.".m2/maven".source = "${pkgs.maven}/maven";
}
