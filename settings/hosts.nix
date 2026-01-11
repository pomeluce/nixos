{ pkgst }:
{
  LTB16P = with pkgst; rec {
    name = "LTB16P";
    config =
      (import ../hosts/${name}/options.nix {
        pkgs = main-pkgs;
        spkgs = stable-pkgs;
        npkgs = npkgs;
      }).opts;
  };
  DLG5 = with pkgst; rec {
    name = "DLG5";
    config =
      (import ../hosts/${name}/options.nix {
        pkgs = main-pkgs;
        spkgs = stable-pkgs;
        npkgs = npkgs;
      }).opts;
  };
  WSN = with pkgst; rec {
    name = "WSN";
    config =
      (import ../hosts/${name}/options.nix {
        pkgs = main-pkgs;
        spkgs = stable-pkgs;
        npkgs = npkgs;
      }).opts;
  };
}
