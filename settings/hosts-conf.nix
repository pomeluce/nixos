{ pkg-settings }:
{
  LTB16P = with pkg-settings; rec {
    name = "LTB16P";
    config = (import ../hosts/${name}/options.nix { pkgs = main-pkgs; }).opts;
  };
  DLG5 = with pkg-settings; rec {
    name = "DLG5";
    config = (import ../hosts/${name}/options.nix { pkgs = main-pkgs; }).opts;
  };
}
