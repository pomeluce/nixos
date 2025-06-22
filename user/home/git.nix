{ lib, opts, ... }:
{
  programs.git = {
    enable = true;
    userName = "${opts.programs.git.name}";
    userEmail = "${opts.programs.git.email}";
    extraConfig = lib.mkMerge [
      ({ init.defaultBranch = "${opts.programs.git.branch}"; })
      (lib.mkIf (opts.system.proxy.enabled == true) {
        http.proxy = "${opts.system.proxy.http}";
        https.proxy = "${opts.system.proxy.https}";
      })
    ];
  };
}
