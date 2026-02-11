{
  stdenv,
  lib,
  fetchgit,
  ...
}:

let
  version = "23f0c39a0b443524e37dbff4f085236b32691291";
  rime-ice = {
    pname = "rime-ice";
    inherit version;
    src = fetchgit {
      url = "https://github.com/iDvel/rime-ice.git";
      rev = "${version}";
      fetchSubmodules = true;
      sha256 = "sha256-Y6/tU63+JQ9HX1m/kI9VQz6tIhFVRAPSsp6Vf47gzUk=";
    };
    date = "2026-02-10";
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
    maintainers = with maintainers; [ pomeluce ];
  };
}
