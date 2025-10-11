{ pkg-settings }:
{
  LTB16P = with pkg-settings; rec {
    name = "LTB16P";
    config =
      (import ../hosts/${name}/options.nix {
        pkgs = main-pkgs;
        spkgs = stable-pkgs;
        npkgs = npkgs;
      }).opts;
  };
  DLG5 = with pkg-settings; rec {
    name = "DLG5";
    config =
      (import ../hosts/${name}/options.nix {
        pkgs = main-pkgs;
        spkgs = stable-pkgs;
        npkgs = npkgs;
      }).opts;
  };
  WSN = with pkg-settings; rec {
    name = "WSN";
    config =
      (import ../hosts/${name}/options.nix {
        pkgs = main-pkgs;
        spkgs = stable-pkgs;
        npkgs = npkgs;
      }).opts;
  };
}
