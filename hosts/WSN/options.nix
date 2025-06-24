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

      bluetooth = false;
      use-mihomo = false;

      desktop.enable = false;
      wm.sddm = false;
      wm.greetd = false;
      wm.hyprland = false;
      wm.gnome = false;
      wm.wsl = true;

      # user env
      session-variables = { };
      session-path = [ ];

      # proxy
      proxy.enabled = false;
      proxy.http = "";
      proxy.https = "";

      # intel, amd, nvidia, intel-nvidia, amd-nvidia
      drive.gpu-type = [ ];
      drive.intel-bus-id = "";
      drive.amd-bus-id = "";
      drive.nvidia-bus-id = "";
    };

    programs = {
      # git config
      git.name = "Tso";
      git.email = "62343478+pomeluce@users.noreply.github.com";
      git.branch = "main";

      firefox.enable = false;
    };

    # packages for this machine
    packages = with pkgs; [ ];
  };
}
