{ pkgs, ... }:
{
  colorscheme = import ./colorscheme { inherit pkgs; };
  utils = import ./utils.nix { };
}
