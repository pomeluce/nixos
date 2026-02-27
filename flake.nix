{
  description = "Marcus's NixOS Configuration";

  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs
  inputs = {
    # --- core source: unified use of nixpkgs (unstable) ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

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
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- external packages/overlay ---
    nur.url = "github:nix-community/NUR";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    akirds = {
      url = "github:pomeluce/akir-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silent-sddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    azimfw = {
      url = "github:pomeluce/akir-zimfw";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      nlib = import ./lib { inherit (nixpkgs) lib; };

      allOverlay = [
        inputs.nur.overlays.default
        (final: prev: {
          npkgs = import ./pkgs { pkgs = final; }; # custom packages repository
          stable = import nixpkgs-stable {
            inherit system;
            config = nlib.nixConfig.nixpkgsConfig;
          };
          neovim-nightly = inputs.neovim-nightly.packages.${system}.default;
          akirds = inputs.akirds.packages.${system}.akirds;
          silent = inputs.silent-sddm.packages.${system}.default;
        })
      ];
      system-gen =
        {
          hostname,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname nlib; };
          modules = [
            { nixpkgs.config = nlib.nixConfig.nixpkgsConfig; }
            { nixpkgs.overlays = allOverlay; }

            ./system/options.nix
            ./hosts/${hostname}
            ./system

            inputs.stylix.nixosModules.stylix
            inputs.sops-nix.nixosModules.sops

            ./user/services

            inputs.home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  users.${config.myOptions.username} = import ./user/home;
                  extraSpecialArgs = {
                    inherit inputs nlib;
                    sysConfig = config;
                    secretsPath = ./secrets.yaml;
                  };
                };
              }
            )
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        LTB16P = system-gen { hostname = "LTB16P"; };
        WSN = system-gen { hostname = "WSN"; };
      };
    };
}
