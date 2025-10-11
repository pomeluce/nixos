{ lib, opts, ... }:
{
  services.keyd = {
    enable = opts.programs.keyd.enable;
    keyboards = {
      defaults = {
        ids = [ "*" ];
        settings = opts.programs.keyd.settings;
      };
    };
  };
  systemd.services.keyd.wantedBy = lib.mkForce [ ];
}
