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

      ml = import ./lib { inherit (nixpkgs) lib; };
      allOverlay = [
        inputs.nur.overlays.default
        (final: prev: {
          npkgs = import ./pkgs { pkgs = final; }; # custom packages repository
          stable = import nixpkgs-stable {
            inherit system;
            config = ml.nixConfig.nixpkgsConfig;
          };
          neovim-nightly = inputs.neovim-nightly.packages.${system}.default;
          akirds = inputs.akirds.packages.${system}.akirds;
          silent = inputs.silent-sddm.packages.${system}.default;
        })
        (self: super: { lib = super.lib // ml; })
      ];
      system-gen =
        {
          hostname,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname; };
          modules = [
            { nixpkgs.config = ml.nixConfig.nixpkgsConfig; }
            { nixpkgs.overlays = allOverlay; }

            ./config
            ./hosts/${hostname}
            ./system
            inputs.stylix.nixosModules.stylix
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            ./user/services

            (
              { config, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  users.${config.mo.username} = {
                    imports = [
                      ./config
                      ./user/home
                    ];
                    mo = config.mo;
                  };
                  extraSpecialArgs = {
                    inherit inputs;
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
