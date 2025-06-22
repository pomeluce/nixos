{ lib, opts, ... }:
{
  imports =
    [ ]
    ++ lib.optionals (opts.system.use-mihomo == true) [
      ./mihomo.nix
    ];
}
