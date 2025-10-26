{ lib, opts, ... }:
{
  programs.git = {
    enable = true;
    settings = lib.mkMerge [
      ({
        user = {
          name = "${opts.programs.git.name}";
          email = "${opts.programs.git.email}";
        };
        init.defaultBranch = "${opts.programs.git.branch}";
      })
      (lib.mkIf (opts.system.proxy.enable == true) {
        http.proxy = "${opts.system.proxy.http}";
        https.proxy = "${opts.system.proxy.https}";
      })
    ];
  };
}
