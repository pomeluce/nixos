{
  config,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.mo.system.nginx;
  sslCert = config.sops.secrets.SSL_CF_PEM.path;
  sslKey = config.sops.secrets.SSL_CF_KEY.path;
in
{
  services.nginx = {
    enable = nginx.enable;
    additionalModules = [ pkgs.nginxModules.brotli ];
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # 自定义访问日志格式: nginx 默认用 logs/access.log + combined,
    # 这里定义 main 格式并切换过去 (路径不变, 只是换了格式).
    commonHttpConfig = ''
      log_format main '$remote_addr - $remote_user [$time_iso8601] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
      access_log logs/access.log main;
    '';

    # 站点配置来自 mo.system.nginx.virtualHosts;
    # 所有站点共用 sops 解密的 CF Origin 证书, host 层只需设
    # forceSSL / addSSL / onlySSL 来启用 HTTPS.
    virtualHosts = lib.mkMerge [
      nginx.virtualHosts
      (lib.mapAttrs (_: _: {
        sslCertificate = sslCert;
        sslCertificateKey = sslKey;
      }) nginx.virtualHosts)
    ];
  };
}
