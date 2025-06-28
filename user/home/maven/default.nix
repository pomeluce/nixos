{ opts, ... }:
let
  buildSettings = import ./settings.xml.nix;
in
{
  home.file.".m2/settings.xml" = {
    text = buildSettings {
      opts = opts;
    };
  };
}
