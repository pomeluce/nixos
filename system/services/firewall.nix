{ config, ... }:
let
  fw = config.mo.system.firewall;
in
{
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    inherit (fw)
      trustedInterfaces
      allowedUDPPorts
      allowedTCPPorts
      allowedTCPPortRanges
      allowedUDPPortRanges
      ;
  };
}
