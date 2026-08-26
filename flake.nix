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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akpkgs = {
      url = "github:pomeluce/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akzsh = {
      url = "github:pomeluce/akiron-zsh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akvim = {
      url = "github:pomeluce/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akmux = {
      url = "github:pomeluce/akiron-mux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silent-sddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elegant-grub2 = {
      url = "github:vinceliuice/elegant-grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- shared agent skills ---
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    ppt-master = {
      url = "github:hugohe3/ppt-master";
      flake = false;
    };
    humanizer = {
      url = "github:blader/humanizer";
      flake = false;
    };
    humanizer-zh = {
      url = "github:op7418/Humanizer-zh";
      flake = false;
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
        templates = import ./templates;
        overlays = import ./overlays { inherit inputs self; };
      };

      perSystem =
        { pkgs, lib, ... }:
        {
          packages = import "${inputs.akpkgs}/pkgs" {
            pkgs = import nixpkgs {
              inherit (pkgs.stdenv.hostPlatform) system;
              config =
                (import ./nix/nixpkgs.nix {
                  inherit lib self;
                }).nixpkgs.config;
            };
          };
          checks = {
            deadnix = pkgs.runCommand "deadnix-check" { } ''
              ${pkgs.deadnix}/bin/deadnix --fail ${./.}
              touch $out
            '';
            statix = pkgs.runCommand "statix-check" { } ''
              ${pkgs.statix}/bin/statix check -c ${./statix.toml} ${./.}
              touch $out
            '';
          };
          formatter = pkgs.nixfmt;
        };
    };
}
