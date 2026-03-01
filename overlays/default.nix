{ inputs, self, ... }:
let
  nc = import ../nix/nixpkgs.nix {
    inherit (inputs.nixpkgs) lib;
    inherit self;
  };
  myLib = import ../lib;
in
{
  additions = final: prev: {
    npkgs = import ../pkgs { pkgs = final; };
  };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config = nc.nixpkgs.config;
    };
    neovim-nightly = inputs.neovim-nightly.packages.${final.system}.default;
    akirds = inputs.akirds.packages.${final.system}.akirds;
    silent = inputs.silent-sddm.packages.${final.system}.default;
    lib = prev.lib // myLib;
  };

  nur = inputs.nur.overlays.default;
}
