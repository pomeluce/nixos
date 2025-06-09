{ lib, opts, ... }: {
  programs.git = {
    enable = true;
    userName = "${opts.git.name}";
    userEmail = "${opts.git.email}";
    extraConfig = lib.mkMerge [
      ({ init.defaultBranch = "${opts.git.branch}"; })
      (lib.mkIf (opts.use-proxy == true) {
        http.proxy = "${opts.http-proxy}";
        https.proxy = "${opts.https-proxy}";
      })
    ];
  };
}
