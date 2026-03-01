{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mo.desktop.enable {
    home.packages = with pkgs; [ typora ];
    home.file.".config/Typora/themes/mdmdt.css".source = ./mdmdt.css;
  };
}
