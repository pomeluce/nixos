{ lib, opts, ... }:
{
  imports =
    [ ]
    ++ lib.optionals (opts.system.wallpaper.enable == true) [
      ./wallpaper.nix
    ]
    ++ lib.optionals (opts.system.mihomo == true) [
      ./firewall.nix
      ./mihomo.nix
    ];
}
