{ lib, opts, ... }:
{
  programs.git = {
    enable = true;
    userName = "${opts.gitname}";
    userEmail = "${opts.gitmail}";
    extraConfig = lib.mkMerge [
      ({ init.defaultBranch = "${opts.gitbranch}"; })
      (lib.mkIf (opts.use-proxy == true) {
        http.proxy = "${opts.http-proxy}";
        https.proxy = "${opts.https-proxy}";
      })
    ];
  };
}
