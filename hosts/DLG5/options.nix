{ pkgs, ... }: {
  opts = rec {
    username = "Tso";

    devroot = "/home/${username}/devroot";

    # packages for this machine
    packages = with pkgs; [ jetbrains.jdk ];

    # git config
    git = {
      name = "Tso";
      email = "62343478+pomeluce@users.noreply.github.com";
      branch = "main";
    };

    wm = { sddm = true; };

    # user env
    sessionVariables = { IDEA_JDK = "${pkgs.jetbrains.jdk}/lib/openjdk"; };
    sessionPath = [ ];

    # proxy
    use-proxy = false;
    http-proxy = "";
    https-proxy = "";
  };
}
