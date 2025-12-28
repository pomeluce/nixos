{
  nixpkgs,
  system,
  nixpkgs-stable,
  nixpkgs-unstable,
  nur,
}:
rec {
  # Superset of the default unfree packages
  allowed-unfree-packages =
    pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      # NVIDIA
      "nvidia-x11"
      "nvidia-settings"

      # CUDA
      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_gdb"
      "cuda_nvcc"
      "cuda_nvdisasm"
      "cuda_nvprune"
      "cuda_cccl"
      "cuda_cudart"
      "cuda_cupti"
      "cuda_cuxxfilt"
      "cuda_nvml_dev"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_profiler_api"
      "cuda_sanitizer_api"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libnvjitlink"
      "libcusparse"
      "libnpp"

      # fonts
      "corefonts"
      "vista-fonts"
      "vista-fonts-chs"
      "ttf-pingfang"
      "ttf-pingfang-relaxed"
      "ttf-pingfang-ui"
      "ttf-pingfang-emoji"

      "reqable"
      "idea"
      "vscode"
      "typora"
      "spotify"
      "steam"
      "steam-unwrapped"
      "xow_dongle-firmware"
      "obsidian"
      "wpsoffice"
      "qq"
      "wechat-universal-bwrap"
    ];
  # Superset of the default insecure packages
  allowed-insecure-packages = [
  ];
  # Main Brach Packages
  main-pkgs = import nixpkgs {
    inherit system;
    config.allowUnfreePredicate = allowed-unfree-packages;
    config.permittedInsecurePackages = allowed-insecure-packages;
    overlays = [ nur.overlays.default ];
  };
  # Stable Brach Packages
  stable-pkgs = import nixpkgs-stable {
    inherit system;
    config.allowUnfreePredicate = allowed-unfree-packages;
    config.permittedInsecurePackages = allowed-insecure-packages;
    overlays = [ nur.overlays.default ];
  };
  # Unstable Brach Packages
  unstable-pkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfreePredicate = allowed-unfree-packages;
    config.permittedInsecurePackages = allowed-insecure-packages;
    overlays = [ nur.overlays.default ];
  };

  npkgs = import ../repos {
    pkgs = main-pkgs;
  };
}
