{
  inputs,
  opts,
  hostname,
  npkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ../hosts/${hostname}/hardware-configuration.nix
    ./configuration.nix
    ./locale.nix
    ./nvidia.nix
    ./opengl.nix
    ./packages.nix
    ./user.nix
    ./env.nix
    ./services.nix
    ./hyprland.nix
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit opts;
      inherit npkgs;
    };
    users.${opts.username} = import ../home;
  };
}
