{ pkgs, ... }:
{
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
      gfxmodeEfi = "1920x1080";
      theme = "${pkgs.npkgs.elegant-theme}/grub/themes/Elegant-mojave-blur-left-dark";
      font = "${pkgs.maple-mono.NormalNL-NF-unhinted}/share/fonts/truetype/MapleMonoNormalNL-NF-Bold.ttf";
    };
  };

  environment.systemPackages = [ pkgs.npkgs.elegant-theme ];
}
