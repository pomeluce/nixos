{ pkgs, config, ... }:
{
  systemd.user.services.cli-proxy-api = {
    Unit = {
      Description = "CliProxyAPI Service";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.npkgs.cli-proxy-api}/bin/cli-proxy-api --config %h/.cpa/config.yaml";
      Restart = "always";
      RestartSec = 10;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.packages = with pkgs; [ npkgs.cli-proxy-api ];

  sops.templates."cpa-config.yaml".content =
    builtins.replaceStrings [ "__CPA_API_KEY__" ] [ "${config.sops.placeholder.CPA_API_KEY}" ]
      (builtins.readFile ./config.yaml);

  home.file.".cpa/config.yaml".source =
    config.lib.file.mkOutOfStoreSymlink
      config.sops.templates."cpa-config.yaml".path;
}
