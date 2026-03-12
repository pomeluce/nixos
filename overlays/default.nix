{ inputs, self, ... }:
let
  nc = import ../nix/nixpkgs.nix {
    inherit (inputs.nixpkgs) lib;
    inherit self;
  };
  myLib = import ../lib { inherit (inputs.nixpkgs) lib; };
in
{
  additions = final: _: {
    npkgs = import ../pkgs { pkgs = final; };
  };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config = nc.nixpkgs.config;
    };
    neovim-nightly = inputs.neovim-nightly.packages.${final.stdenv.hostPlatform.system}.default;
    akirds = inputs.akirds.packages.${final.stdenv.hostPlatform.system}.akirds;
    silent = inputs.silent-sddm.packages.${final.stdenv.hostPlatform.system}.default;
    lib = prev.lib // myLib;
  };

  nur = inputs.nur.overlays.default;
}
