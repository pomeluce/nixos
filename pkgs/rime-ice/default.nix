{
  stdenv,
  lib,
  fetchgit,
  ...
}:

let
  version = "c0364c0f3bbf9559c992f166795d6eb474a4a745";
  rime-ice = {
    pname = "rime-ice";
    inherit version;
    src = fetchgit {
      url = "https://github.com/iDvel/rime-ice.git";
      rev = "${version}";
      fetchSubmodules = true;
      sha256 = "sha256-QLZrYqYqPiTfOmFE/Oo8YSp3IavqyLyZxnQ52N5+es0=";
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
