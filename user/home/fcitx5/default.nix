{ pkgs, npkgs, ... }:
let
  themes = ".local/share/fcitx5/themes";
  gruvbox = pkgs.fetchFromGitHub {
    owner = "ayamir";
    repo = "fcitx5-gruvbox";
    rev = "80bd3ab4c723fc6fcc4a222b6cede6f8337eedda";
    sha256 = "UZc6UTpodxP3pJ6q58FZsJaHr1Wwl/NLYYmo22QYmNk=";
  };
in
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

  home.file = {
    "${themes}/Gruvbox-Dark".source = "${gruvbox}/Gruvbox-Dark";
    "${themes}/Gruvbox-Light".source = "${gruvbox}/Gruvbox-Light";
    "${themes}/macos-light".source = ./themes/macos-light;
    "${themes}/macos-dark".source = ./themes/macos-dark;
  };
}
