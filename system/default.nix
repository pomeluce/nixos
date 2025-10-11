# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  lib,
  inputs,
  config,
  opts,
  hostname,
  allowed-unfree-packages,
  allowed-insecure-packages,
  ...
}:
{
  # Unfree Packages
  nixpkgs.config = {
    allowUnfreePredicate = allowed-unfree-packages;
    permittedInsecurePackages = allowed-insecure-packages;
  };

  imports =
    lib.optionals (opts.system.wsl != true) [
      # Include the results of the hardware scan.
      ../hosts/${hostname}/hardware-configuration.nix
    ]
    ++ [
      ./user.nix
      ./packages.nix
      ./env.nix
      ./locale.nix
      ./modules/boot.nix
      ./modules/opengl.nix
      ./modules/gc.nix
      ./modules/sops.nix
      ./services/xserver.nix
      ./services/pipewire.nix
      ./services/keyd.nix
      ./services/upower.nix
      ./services/others.nix
    ]
    ++ lib.optionals (opts.system.desktop.enable == true) [
      ./modules/xdg.nix
    ]
    ++ lib.optionals (opts.system.bluetooth == true) [
      ./modules/bluetooth.nix
    ]
    ++ lib.optionals (builtins.elem "nvidia" opts.system.drive.gpu-type) [
      ./modules/nvidia.nix
    ]
    ++ lib.optionals (builtins.elem "intel-nvidia" opts.system.drive.gpu-type) [
      ./modules/nvidia.nix
    ]
    ++ lib.optionals (builtins.elem "amd-nvidia" opts.system.drive.gpu-type) [
      ./modules/nvidia.nix
    ]
    ++ lib.optionals (opts.system.gnome.enable == true) [
      ./modules/gnome.nix
    ]
    ++ lib.optionals (opts.system.hyprland.enable == true) [
      ./modules/hyprland.nix
    ]
    ++ lib.optionals (opts.system.postgres == true) [
      ./services/postgres.nix
    ]
    ++ lib.optionals (opts.programs.steam.enable == true) [
      ./modules/steam.nix
    ]
    ++ lib.optionals (opts.system.docker == true) [
      ./modules/docker.nix
    ]
    ++ lib.optionals (opts.system.virt.enable == true) [
      ./modules/virt.nix
    ]
    ++ lib.optionals (opts.system.wsl == true) [
      "${inputs.nixos-wsl}/modules"
      ./modules/wsl.nix
    ];

  networking.hostName = "${hostname}"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.extraOptions = ''
    !include ${config.sops.secrets.ACCESS_TOKEN.path}
  '';

  # List programs that you want to enable:
  programs.dconf.enable = true;
  programs.zsh.enable = true;

  # Proxy
  systemd.services.nix-daemon.environment = lib.mkMerge [
    (lib.mkIf (opts.system.proxy.enable == true) {
      http_proxy = "${opts.system.proxy.http}";
      https_proxy = "${opts.system.proxy.https}";
    })
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
