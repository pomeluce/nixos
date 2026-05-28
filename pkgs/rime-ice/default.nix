{
  stdenv,
  lib,
  fetchgit,
  ...
}:

let
  version = "e0b1588f8ca405fb81dfd92235ecd5bdccfa18ce";
  rime-ice = {
    pname = "rime-ice";
    inherit version;
    src = fetchgit {
      url = "https://github.com/iDvel/rime-ice.git";
      rev = "${version}";
      fetchSubmodules = true;
      sha256 = "sha256-3R/g2QKPY3KkZGjGNQP8GcaVT/LkN3FkBmpyQz5sSfI=";
    };
  };
in
stdenv.mkDerivation {
  inherit (rime-ice) pname version src;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/rime-data"
    cp -r * "$out/share/rime-data"

    install -Dm644 ${./default.custom.yaml} "$out/share/rime-data/default.custom.yaml"
    install -Dm644 ${./double_pinyin_flypy.custom.yaml} "$out/share/rime-data/double_pinyin_flypy.custom.yaml"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/iDvel/rime-ice";
    description = "A long-term maintained simplified Chinese RIME schema";
    license = licenses.gpl3;
  };
}
