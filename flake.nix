{
  description = "Marcus's NixOS Configuration";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs
  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Stable
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    # Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # HomeManager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NUR
    nur.url = "github:nix-community/NUR";
    # ashell
    ashell = {
      url = "github:pomeluce/akir-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      nur,
      ashell,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # Packages Setting
      pkg-settings = import ./settings/pkgs-settings.nix {
        inherit nixpkgs;
        inherit system;
        inherit nixpkgs-stable;
        inherit nixpkgs-unstable;
        inherit nur;
      };
      # Host Config
      hosts-conf = import ./settings/hosts-conf.nix { inherit pkg-settings; };
      # Generate Function
      system-gen =
        { host-conf }:
        with pkg-settings;
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit allowed-unfree-packages;
            inherit allowed-insecure-packages;
            inherit npkgs;
            opts = host-conf.config;
            hostname = host-conf.name;
          };
          modules = [
            # Add NUR
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            # Add Stable Nixpkgs
            ({
              nixpkgs.overlays = [
                (final: prev: {
                  stable = stable-pkgs;
                  ashell = ashell.packages.${system};
                })
              ];
            })
            # System Configuration
            ./system
            # HomeManager
            home-manager.nixosModules.home-manager
          ];
        };
    in
    {
      nixosConfigurations = with hosts-conf; {
        "${LTB16P.name}" = system-gen { host-conf = LTB15P; };
        "${DLG5.name}" = system-gen { host-conf = DLG5; };
      };
    };
}
