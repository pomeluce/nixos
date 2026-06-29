{
  config,
  lib,
  pkgs,
  ...
}:
let
  bootConfig = config.mo.system.boot;
in
{
  assertions = [
    {
      assertion = bootConfig.mode != "bios" || bootConfig.device != "nodev";
      message = "BIOS boot mode requires mo.system.boot.device to be a real disk device, for example /dev/vda.";
    }
  ];

  boot.loader = lib.mkMerge [
    {
      grub = {
        enable = lib.mkDefault true;
        useOSProber = true;
        device = bootConfig.device;
        # gfxmodeEfi = "1920x1080";
        # theme = "${pkgs.elegant-theme}/grub/themes/Elegant-mojave-blur-left-dark";
        font = "${pkgs.maple-mono.NormalNL-NF-unhinted}/share/fonts/truetype/MapleMonoNormalNL-NF-Bold.ttf";
      };
      elegant-grub2-theme = {
        enable = true;
        theme = "mojave";
        screen = "1080p";
        type = "blur";
        color = "dark";
        side = "left";
        logo = "system";
      };
    }

    (lib.mkIf (bootConfig.mode == "efi") {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub.efiSupport = true;
    })
  ];
}
