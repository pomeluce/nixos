{ config, lib, ... }:
let
  mo = config.mo;
in
{
  programs.git = {
    enable = true;
    settings = lib.mkMerge [
      {
        user = {
          name = "${mo.programs.git.name}";
          email = "${mo.programs.git.email}";
        };
        init.defaultBranch = "${mo.programs.git.branch}";
      }
      (lib.mkIf (mo.system.proxy.enable == true) {
        http.proxy = "${mo.system.proxy.http}";
        https.proxy = "${mo.system.proxy.https}";
      })
    ];
  };
}
