{ lib, ... }:
rec {
  allowed-unfree-packages = [
    # lsp & dap
    "copilot-language-server"
    "vscode-extension-ms-vscode-cpptools"

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
    "xone-dongle-firmware"
    "obsidian"
    "wpsoffice-cn"
    "qq"
    "wechat-universal-bwrap"
  ];

  allowed-insecure-packages = [
  ];

  nixpkgsConfig = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
    permittedInsecurePackages = allowed-insecure-packages;
  };
}
