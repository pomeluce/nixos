{ pkgs, opts, ... }:
let
  buildSettings = import ./settings.xml.nix;
in
{
  home.file.".m2/settings.xml" = {
    text = buildSettings {
      opts = opts;
    };
  };

  home.file.".m2/maven".source = "${pkgs.maven}/maven";
}
