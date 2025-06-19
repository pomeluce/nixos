{
  nixpkgs,
  system,
  nixpkgs-stable,
  nixpkgs-unstable,
  nur,
}:
rec {
  # Superset of the default unfree packages
  allowed-unfree-packages =
    pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      "pingfang"
      "pingfang-relaxed"
      "pingfang-ui"
      "idea-ultimate"
      "vscode"
      "spotify"
    ];
  # Superset of the default insecure packages
  allowed-insecure-packages = [
  ];
  # Main Brach Packages
  main-pkgs = import nixpkgs {
    inherit system;
    config.allowUnfreePredicate = allowed-unfree-packages;
    config.permittedInsecurePackages = allowed-insecure-packages;
    overlays = [ nur.overlays.default ];
  };
  # Stable Brach Packages
  stable-pkgs = import nixpkgs-stable {
    inherit system;
    config.allowUnfreePredicate = allowed-unfree-packages;
    config.permittedInsecurePackages = allowed-insecure-packages;
    overlays = [ nur.overlays.default ];
  };
  # Unstable Brach Packages
  unstable-pkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfreePredicate = allowed-unfree-packages;
    config.permittedInsecurePackages = allowed-insecure-packages;
    overlays = [ nur.overlays.default ];
  };

  npkgs = import ../repos {
    pkgs = main-pkgs;
  };
}
