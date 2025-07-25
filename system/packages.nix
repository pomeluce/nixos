{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh
    wget
    curl
    git
    neovim

    which
    file
    zip
    unzip
    xz
    p7zip
    ripgrep
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
    htop
    cliphist
    microcode-intel

    gcc
    gnumake
    cmake
    meson
    ninja
    rustc
    cargo
    python3
    nodejs_24
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
    package = pkgs.zulu;
  };

  environment.etc."jdk/zulu21".source = "${pkgs.zulu}";
}
