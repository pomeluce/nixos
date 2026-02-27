{ config, lib, ... }:
{
  config = lib.mkIf config.myOptions.system.bluetooth {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}
