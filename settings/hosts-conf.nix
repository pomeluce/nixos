{pkg-settings}:
{
  DLG5 = with pkg-settings; rec {
    name = "DLG5";
    config = (import ../hosts/${name}/options.nix { pkgs = main-pkgs; }).opts;
  };
}
