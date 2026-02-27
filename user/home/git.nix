{ sysConfig, lib, ... }:
let
  cfg = sysConfig.myOptions;
in
{
  programs.git = {
    enable = true;
    settings = lib.mkMerge [
      {
        user = {
          name = "${cfg.programs.git.name}";
          email = "${cfg.programs.git.email}";
        };
        init.defaultBranch = "${cfg.programs.git.branch}";
      }
      (lib.mkIf (cfg.system.proxy.enable == true) {
        http.proxy = "${cfg.system.proxy.http}";
        https.proxy = "${cfg.system.proxy.https}";
      })
    ];
  };
}
