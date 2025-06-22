{ pkgs, opts, ... }:
{
  boot.kernelModules = [ "tun" ];
  programs.clash-verge = {
    enable = opts.system.clash;
    tunMode = true;
    package = pkgs.clash-verge-rev;
  };

  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 53 ];

  networking.firewall.extraCommands = ''
    # 允许所有来自或发往 tun+ 接口的流量
    iptables -I OUTPUT -o tun+ -j ACCEPT
    iptables -I INPUT -i tun+ -j ACCEPT
  '';

  systemd.services.clash-verge = {
    description = "Clash Verge TUN Mode Service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.clash-verge-rev}/bin/clash-verge-service";
      Restart = "on-failure";
      AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
      CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
      DeviceAllow = "/dev/net/tun";
    };
  };
}
