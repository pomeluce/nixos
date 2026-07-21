{
  config,
  lib,
  pkgs,
  ...
}:
let
  mo = config.mo;
in
{
  /*
    https://www.cactily.me/2025/07/30/%E6%98%BE%E5%8D%A1%E7%9B%B4%E9%80%9A%E6%96%B9%E6%A1%88
    https://lostattractor.net/archives/nixos-gpu-vfio-passthrough

    热切换方案: nvidia 驱动正常加载并初始化 GPU BAR, VM 启动前由
    libvirt hook 将 GPU 从 nvidia 切换到 vfio-pci, VM 关闭后切回.
    这样 VM 不运行时 NVIDIA 仍可被宿主机使用.
    详细文档参见 docs/passthrough.md
  */

  config = lib.mkIf mo.system.virt.enable {
    # intel iommu enabled
    boot = {
      kernelParams = [
        "intel_iommu=on"
        "video=efifb:off"
      ];
      extraModprobeConfig = ''
        options kvm_${mo.system.virt.kvm-cpu-type} nested=1
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
        };
      };
      # usb redirection for virtual machines
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;

    # Looking Glass (画面回传) + virtiofsd (VirtIO-FS 文件共享守护进程)
    environment.systemPackages = [
      pkgs.looking-glass-client
      pkgs.virtiofsd
    ];

    # /dev/shm/looking-glass 由 tmpfiles 创建 ($USER:libvirtd 权限),
    # VM 启动时 QEMU 会按 shmem 配置的大小使用它.
    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${mo.username} libvirtd -"
    ];

    # libvirt QEMU hook: VM 启动前将 NVIDIA GPU 切换给 vfio-pci,
    # VM 关闭后切回 nvidia 驱动 (热切换). 详见 docs/passthrough.md
    environment.etc."libvirt/hooks/qemu" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        # libvirt QEMU hook: NVIDIA GPU 热切换 (nvidia <-> vfio-pci)
        set -u
        GUEST="$1"
        ACTION="$2"

        # 动态查找所有 NVIDIA PCI 设备 (VGA + Audio 等)
        DEVS=$(lspci -Dnn 2>/dev/null | grep -i 'NVIDIA' | awk '{print $1}')
        [ -z "$DEVS" ] && exit 0

        log() { logger -t kvm-gpu-hook "$*"; }

        to_vfio() {
          log "prepare: switching to vfio-pci for: $DEVS"
          # 杀掉占用 nvidia 设备的进程 (niri 已 ignore-drm-device, 一般无残留)
          fuser -k -9 /dev/nvidia* 2>/dev/null || true
          sleep 1
          # 卸载 nvidia 内核模块
          modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia 2>/dev/null || true
          # 解绑当前驱动
          for d in $DEVS; do
            drv=$(basename "$(readlink -f /sys/bus/pci/devices/$d/driver)" 2>/dev/null || true)
            if [ -n "$drv" ]; then
              echo "$d" > /sys/bus/pci/drivers/$drv/unbind 2>/dev/null || true
            fi
          done
          # vfio-pci 接管 (driver_override + drivers_probe)
          modprobe vfio-pci 2>/dev/null || true
          for d in $DEVS; do
            echo "vfio-pci" > /sys/bus/pci/devices/$d/driver_override 2>/dev/null || true
            echo "$d" > /sys/bus/pci/drivers_probe 2>/dev/null || true
          done
          sleep 1
          log "prepare done"
        }

        to_nvidia() {
          log "release: restoring default drivers for: $DEVS"
          for d in $DEVS; do
            echo "$d" > /sys/bus/pci/drivers/vfio-pci/unbind 2>/dev/null || true
            # 清除 driver_override, 让默认驱动 (nvidia / snd_hda_intel) 重新绑定
            echo "" > /sys/bus/pci/devices/$d/driver_override 2>/dev/null || true
            echo "$d" > /sys/bus/pci/drivers_probe 2>/dev/null || true
          done
          # 确保 nvidia 模块加载
          modprobe nvidia 2>/dev/null || true
          modprobe snd_hda_intel 2>/dev/null || true
          log "release done"
        }

        case "$ACTION" in
          prepare) to_vfio ;;
          release) to_nvidia ;;
        esac
        exit 0
      '';
    };
  };
}
