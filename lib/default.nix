{ lib, ... }:
{
  utils = import ./utils.nix { };
  nixConfig = import ./nix-config.nix { inherit lib; };
}
