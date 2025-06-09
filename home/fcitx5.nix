{
  lib,
  pkgs,
  npkgs,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-configtool
        (fcitx5-rime.override {
          rimeDataPkgs = with npkgs; [ rime-ice ];
        })
      ];
    };
  };

  home.activation.rimeIce = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -snf "$DEVROOT/wsp/dotfiles/fcitx5/themes" "$HOME/.local/share/fcitx5/themes"
  '';
}
