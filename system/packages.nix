{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh
    nushell
    wget
    curl
    git
    neovim
    home-manager
    nix-update

    which
    file
    zip
    unzip
    xz
    p7zip
    gawk
    zstd
    lsof
    pciutils
    usbutils
    dconf
    shared-mime-info
    glib
    xdg-utils
    psmisc
    flex
    bison
    iptables
    usbmuxd
    libimobiledevice
    btop-cuda
    cliphist
    microcode-intel
    sops
    android-tools
    translate-shell
    imagemagick

    gcc
    gdb
    gnumake
    cmake
    meson
    ninja
    rustc
    cargo
    python3
    nodejs_26
    pnpm
    yarn
    typescript
    go
    lua
    maven
    gradle
  ];

  programs.java = {
    enable = true;
    package = pkgs.zulu21;
  };

  environment.etc."jdk/zulu25".source = "${pkgs.zulu25}";
  environment.etc."jdk/zulu21".source = "${pkgs.zulu21}";
  environment.etc."jdk/zulu8".source = "${pkgs.zulu8}";
}
