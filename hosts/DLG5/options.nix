{ pkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      fontSize = {
        wezterm = 14;
        swaylock = 18;
      };

      cursor = {
        size = 24;
      };

      gtk = {
        scale = {
          text = 1;
        };
      };

      wm = {
        sddm = true;
      };

      # user env
      sessionVariables = {
        IDEA_JDK = "${pkgs.jetbrains.jdk}/lib/openjdk";
      };
      sessionPath = [ ];

      # proxy
      proxy = {
        enabled = false;
        http = "";
        https = "";
      };
    };

    programs = {
      # git config
      git = {
        name = "Tso";
        email = "62343478+pomeluce@users.noreply.github.com";
        branch = "main";
      };
    };

    # packages for this machine
    packages = with pkgs; [
      jetbrains.jdk
      jetbrains.idea-ultimate
      vscode
      firefox
      telegram-desktop
      spotify
    ];

  };
}
