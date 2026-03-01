{ config, lib, ... }:
let
  mo = config.mo;
in
{
  config = lib.mkIf mo.desktop.enable {
    services.keyd = {
      enable = mo.programs.keyd.enable;
      keyboards = {
        defaults = {
          ids = [ "*" ];
          settings = mo.programs.keyd.settings;
        };
      };
    };
    systemd.services.keyd.wantedBy = lib.mkForce [ ];
  };
}
