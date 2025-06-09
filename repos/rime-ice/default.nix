{
  stdenv,
  lib,
  fetchgit,
  ...
}:

let
  rime-ice = {
    pname = "rime-ice";
    version = "904aedb7c2097309e4f5a9be29baf6ce5cc64415";
    src = fetchgit {
      url = "https://github.com/iDvel/rime-ice.git";
      rev = "904aedb7c2097309e4f5a9be29baf6ce5cc64415";
      fetchSubmodules = true;
      sha256 = "sha256-a0b6k0dOwrdxCf+ZcX/fiF4K1LLGuEw5eBriRFkY2AI=";
    };
    date = "2025-05-25";
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
