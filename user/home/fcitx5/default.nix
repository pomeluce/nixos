{ pkgs, npkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        (fcitx5-rime.override {
          rimeDataPkgs = with npkgs; [ rime-ice ];
        })
      ];
    };
  };

  home.file.".local/share/fcitx5/themes".source = ./themes;
}
