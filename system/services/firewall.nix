{
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = [
      "tun*"
      "Meta"
      "virbr0"
      "vnet0"
    ];
    # allowedUDPPorts = [];

    allowedTCPPorts = [
      80
      443
      7890
    ];
    # allowedUDPPortRanges = [];
  };
}
