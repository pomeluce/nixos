{
  description = "Marcus's NixOS Configuration";

  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs
  inputs = {
    # --- core source: unified use of nixpkgs (unstable) ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unsmall.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # --- tools and modules ---
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- external packages/overlay ---
    nur.url = "github:nix-community/NUR";
    azimfw = {
      url = "github:pomeluce/akir-zimfw";
      flake = false;
    };
    akirds = {
      url = "github:pomeluce/akir-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silent-sddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./hosts
        { _module.args = { inherit inputs self nixpkgs; }; }
      ];
      flake = {
        overlays = import ./overlays { inherit inputs self; };
      };

      perSystem =
        { pkgs, ... }:
        {
          packages = import ./pkgs { inherit pkgs; };
          checks = {
            deadnix = pkgs.runCommand "deadnix-check" { } ''
              ${pkgs.deadnix}/bin/deadnix --fail ${./.}
              touch $out
            '';
          };

          formatter = pkgs.nixfmt;
        };
    };
}
