{
  description = "Marcus's NixOS Configuration";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs
  inputs = {
    # official nixos package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # stable
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    # unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nur
    nur.url = "github:nix-community/NUR";
    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # akir-shell
    akirshell = {
      url = "github:pomeluce/akir-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wsl module
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # sddm theme
    silent-sddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # akir-zimfw
    azimfw = {
      url = "github:pomeluce/akir-zimfw";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-unstable,
      nur,
      home-manager,
      akirshell,
      sops-nix,
      nixos-wsl,
      silent-sddm,
      azimfw,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # packages setting
      pkg-settings = import ./settings/pkgs-settings.nix {
        inherit nixpkgs;
        inherit system;
        inherit nixpkgs-stable;
        inherit nixpkgs-unstable;
        inherit nur;
      };
      # host config
      hosts-conf = import ./settings/hosts-conf.nix { inherit pkg-settings; };
      # generate function
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
            # add nur
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            # add stable nixpkgs
            ({
              nixpkgs.overlays = [
                (final: prev: {
                  stable = stable-pkgs;
                  akirshell = akirshell.packages.${system};
                  silent = silent-sddm.packages.${system}.default;
                })
              ];
            })
            # system configuration
            ./system
            # user's services
            ./user/services
            # sops-nix
            sops-nix.nixosModules.sops
            # home manager
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${host-conf.config.username} = import ./user/home;
                extraSpecialArgs = {
                  inherit inputs;
                  inherit npkgs;
                  opts = host-conf.config;
                };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = with hosts-conf; {
        "${LTB16P.name}" = system-gen { host-conf = LTB16P; };
        "${DLG5.name}" = system-gen { host-conf = DLG5; };
        "${WSN.name}" = system-gen { host-conf = WSN; };
      };
    };
}
