{ config, lib, ... }:
let
  cfg = config.myOptions;
in
{
  config = lib.mkIf cfg.desktop.enable {
    services.keyd = {
      enable = cfg.programs.keyd.enable;
      keyboards = {
        defaults = {
          ids = [ "*" ];
          settings = cfg.programs.keyd.settings;
        };
      };
    };
    systemd.services.keyd.wantedBy = lib.mkForce [ ];
  };
}
