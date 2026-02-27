{
  sysConfig,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf sysConfig.myOptions.desktop.enable {
    home.packages = with pkgs; [ typora ];
    home.file.".config/Typora/themes/mdmdt.css".source = ./mdmdt.css;
  };
}
