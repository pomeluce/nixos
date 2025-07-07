{
  stdenv,
  lib,
  fetchgit,
  ...
}:

let
  rime-ice = {
    pname = "rime-ice";
    version = "7acdee60d09602383b6299d1bdaaba03f0a57869";
    src = fetchgit {
      url = "https://github.com/iDvel/rime-ice.git";
      rev = "7acdee60d09602383b6299d1bdaaba03f0a57869";
      fetchSubmodules = true;
      sha256 = "sha256-yCVcTc8qitar5JJfVTH4xNJMTPgx/NsRMoTxVm5PVrY=";
    };
    date = "2025-07-06";
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
