{
  inputs,
  nixpkgs,
  self,
  ...
}:
let
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
          inputs.sops-nix.nixosModules.sops
          # inputs.home-manager.nixosModules.home-manager
        ];
      };

      homeConfigurations."${host}" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          inherit
            ((import ../nix/nixpkgs.nix {
              inherit self;
              inherit (inputs.nixpkgs) lib;
            }).nixpkgs
            )
            config
            overlays
            ;
        };
        extraSpecialArgs = {
          inherit inputs self host;
        }
        // extraHomeArgs;
        modules = extraHomeModules ++ [
          ./options.nix
          ./${host}
          ../home
          inputs.sops-nix.homeManagerModules.sops
          inputs.noctalia.homeModules.default
        ];
      };
    };
in
{
  flake =
    import ./hosts.nix |> map mkHost |> builtins.foldl' (x: y: nixpkgs.lib.recursiveUpdate x y) { };
}
