{
  inputs,
  nixpkgs,
  self,
  ...
}:
let
  nc = import ../nix/nixpkgs.nix {
    inherit self;
    inherit (inputs.nixpkgs) lib;
  };

  mkHost =
    {
      host,
      extraOSModules ? [ ],
      extraOSArgs ? { },
      extraHomeModules ? [ ],
      extraHomeArgs ? { },
      ...
    }:
    {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            nixpkgs
            self
            host
            ;
        }
        // extraOSArgs;

        modules = extraOSModules ++ [
          ./options.nix
          ../nix
          ./${host}
          ../system
          ../user/services
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          # inputs.home-manager.nixosModules.home-manager
        ];
      };

      homeConfigurations."${host}" = inputs.home-manager.lib.homeManagerConfiguration {
        # pkgs = nixpkgs.legacyPackages."x86_64-linux";
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = nc.nixpkgs.config;
          overlays = nc.nixpkgs.overlays;
        };
        extraSpecialArgs = {
          inherit inputs self host;
          secretsPath = ../secrets.yaml;
        }
        // extraHomeArgs;
        modules = extraHomeModules ++ [
          ./options.nix
          ./${host}
          ../user/home
          inputs.stylix.homeModules.stylix
        ];
      };
    };
in
{
  flake =
    import ./hosts.nix |> map mkHost |> builtins.foldl' (x: y: nixpkgs.lib.recursiveUpdate x y) { };
}
