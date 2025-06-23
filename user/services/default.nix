{ lib, opts, ... }:
{
  imports =
    [ ]
    ++ lib.optionals (opts.system.use-mihomo == true) [
      ./firewall.nix
      ./mihomo.nix
    ];
}
