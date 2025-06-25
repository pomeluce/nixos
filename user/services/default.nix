{ lib, opts, ... }:
{
  imports =
    [ ]
    ++ lib.optionals (opts.system.mihomo == true) [
      ./firewall.nix
      ./mihomo.nix
    ];
}
