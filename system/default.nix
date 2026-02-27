# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  lib,
  config,
  hostname,
  inputs,
  ...
}:
let
  cfg = config.myOptions;
in
{
  imports = [
    # 基础模块
    ./user.nix
    ./packages.nix
    ./env.nix
    ./locale.nix
    ./modules/boot.nix
    ./modules/opengl.nix
    ./modules/gc.nix
    ./modules/sops.nix

    # 功能模块
    ./modules/bluetooth.nix
    ./modules/nvidia.nix
    ./modules/steam.nix
    ./modules/docker.nix
    ./modules/virt.nix
    ./modules/wsl.nix
    ./modules/desktop
    ./modules/xdg.nix

    # 服务模块
    ./services/pipewire.nix
    ./services/upower.nix
    ./services/keyd.nix
    ./services/xserver.nix
    ./services/postgres.nix
    ./services/others.nix

    # 外部模块
    "${inputs.nixos-wsl}/modules"
  ];

  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.extraOptions = ''
    !include ${config.sops.secrets.ACCESS_TOKEN.path}
  '';

  programs.dconf.enable = true;
  programs.zsh.enable = true;

  systemd.services.nix-daemon.environment = lib.mkIf cfg.system.proxy.enable {
    http_proxy = cfg.system.proxy.http;
    https_proxy = cfg.system.proxy.https;
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
