{
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = [
      "tun*"
      "Meta"
    ];
    # allowedUDPPorts = [];

    allowedTCPPorts = [ 7890 ];
    # allowedUDPPortRanges = [];
  };
}
