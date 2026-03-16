{
  pkgs,
  lib ? import <nixpkgs/lib>,
  ...
}:
{
  colorscheme = import ./colorscheme { inherit pkgs; };
  utils = import ./utils.nix { inherit lib; };
}
