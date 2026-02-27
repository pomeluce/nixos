{ lib, config, ... }:
let
  cfg = config.myOptions.programs.docker;
in
{
  config = lib.mkIf config.myOptions.system.docker {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        # 自动让环境变量 DOCKER_HOST 指向用户的 rootless socket
        setSocketVariable = true;
        daemon.settings = {
          experimental = true;
          data-root = "${cfg.data-root}";
          exec-opts = cfg.exec-opts;
          insecure-registries = cfg.insecure-registries;
          registry-mirrors = cfg.registry-mirrors;
        };
      };
    };
  };
}
