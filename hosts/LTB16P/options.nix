{ pkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      font-size.wezterm = 20;
      font-size.swaylock = 32;
      cursor.size = 36;
      gtk.scale = 1;

      bluetooth = true;
      clash = true;
      wm.sddm = true;
      wm.greetd = false;
      wm.hyprland = true;
      wm.gnome = true;

      # user env
      session-variables = {
        IDEA_JDK = "${pkgs.jetbrains.jdk}/lib/openjdk";
      };
      session-path = [ ];

      # proxy
      proxy.enabled = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ "intel-nvidia" ];
      drive.intel-bus-id = "PCI:0:2:0";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "PCI:1:0:0";
    };

    programs = {
      # git config
      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";
    };

    # packages for this machine
    packages = with pkgs; [
      jetbrains.jdk
      jetbrains.idea-ultimate
      vscode
      firefox
      telegram-desktop
      spotify
      steam
      reqable
    ];
  };
}
