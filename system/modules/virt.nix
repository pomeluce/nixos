{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myOptions.system.virt;
in
{
  /*
    https://www.cactily.me/2025/07/30/%E6%98%BE%E5%8D%A1%E7%9B%B4%E9%80%9A%E6%96%B9%E6%A1%88
    https://lostattractor.net/archives/nixos-gpu-vfio-passthrough
  */

  config = lib.mkIf cfg.enable {
    # intel iommu enabled
    boot = {
      kernelParams = [ ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.kvm-gpu-ids) ];
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
      extraModprobeConfig = ''
        options kvm_${cfg.kvm-cpu-type} nested=1
      '';
    };

    # virtualisation
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      # usb redirection for virtual machines
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
