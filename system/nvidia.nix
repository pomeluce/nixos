{
  config,
  lib,
  opts,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nvtopPackages.full
  ];

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = lib.mkMerge [
    {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    }

    (lib.mkIf opts.system.diver.prime-enable {
      prime = lib.mkMerge [
        (lib.mkIf (builtins.elem "intel-nvidia" opts.system.diver.gpu-type) {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = "${opts.system.diver.intel-bus-id}";
          nvidiaBusId = "${opts.system.diver.nvidia-bus-id}";
        })
        (lib.mkIf (builtins.elem "amd-nvidia" opts.system.diver.gpu-type) {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          amdgpuBusId = "${opts.system.diver.amd-bus-id}";
          nvidiaBusId = "${opts.system.diver.nvidia-bus-id}";
        })
      ];
    })
  ];
}
