{
  opts,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      # 自动让环境变量 DOCKER_HOST 指向用户的 rootless socket
      setSocketVariable = true;
      daemon.settings = {
        experimental = true;
        data-root = "${opts.programs.docker.data-root}";
        exec-opts = opts.programs.docker.exec-opts;
        insecure-registries = opts.programs.docker.insecure-registries;
        registry-mirrors = opts.programs.docker.registry-mirrors;
      };
    };
  };
}
