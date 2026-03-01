{ config, ... }:
{
  imports = [
    ./nixpkgs.nix
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    extraOptions = ''
      !include ${config.sops.secrets.ACCESS_TOKEN.path}
    '';
  };
}
