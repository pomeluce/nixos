{ pkgs, ... }:
{
  opts = rec {
    username = "Tso";
    uid = 1000;
    gid = 1000;

    devroot = "/home/${username}/devroot";

    system = {
      font-size = {
        wezterm = 20;
        swaylock = 32;
      };

      cursor = {
        size = 36;
      };

      gtk = {
        scale = 1;
      };

      wm = {
        sddm = true;
        hyprland = true;
      };

      # user env
      session-variables = {
        IDEA_JDK = "${pkgs.jetbrains.jdk}/lib/openjdk";
      };
      session-path = [ ];

      # proxy
      proxy = {
        enabled = false;
        http = "";
        https = "";
      };

      diver = {
        prime-enable = true;
        # intel, amd, nvidia, intel-nvidia, amd-nvidia
        gpu-type = [ "intel-nvidia" ];
        intel-bus-id = "PCI:0:2:0";
        amd-bus-id = "";
        nvidia-bus-id = "PCI:1:0:0";
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
