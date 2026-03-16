{ pkgs, ... }:
{
  recolor = import ./recolor.nix { inherit pkgs; };
}
