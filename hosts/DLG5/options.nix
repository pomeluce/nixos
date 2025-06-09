{ pkgs, ... }: {
  opts = rec {
    username = "Tso";

    # packages for this machine
    packages = with pkgs; [ jetbrains.jdk ];

    # git config
    gitname = "Tso";
    gitmail = "62343478+pomeluce@users.noreply.github.com";
    gitbranch = "main";

    devroot = "~/devroot";

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
