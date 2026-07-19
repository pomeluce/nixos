{ config, lib, ... }: {

  config = lib.mkIf config.mo.system.virt.enable {
    programs.looking-glass-client = {
      enable = true;
      settings = {
        input = {
          escapeKey = 67;
        };
        win = {
          fullScreen = true;
        };
      };
    };
  };
}
