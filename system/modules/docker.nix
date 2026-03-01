{ lib, config, ... }:
let
  mo = config.mo;
in
{
  config = lib.mkIf mo.system.docker {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        # 自动让环境变量 DOCKER_HOST 指向用户的 rootless socket
        setSocketVariable = true;
        daemon.settings = {
          experimental = true;
          data-root = "${mo.programs.docker.data-root}";
          exec-opts = mo.programs.docker.exec-opts;
          insecure-registries = mo.programs.docker.insecure-registries;
          registry-mirrors = mo.programs.docker.registry-mirrors;
        };
      };
    };
  };
}
