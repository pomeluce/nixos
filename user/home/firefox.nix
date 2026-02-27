{ sysConfig, lib, ... }:
{
  config = lib.mkIf sysConfig.myOptions.desktop.enable {
    programs.firefox = {
      enable = sysConfig.myOptions.programs.firefox.enable;
      profiles.default = {
        name = "Default";
        settings = {
          "browser.tabs.loadInBackground" = true;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
        };
      };
    };
  };
}
