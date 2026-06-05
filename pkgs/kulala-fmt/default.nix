{
  lib,
  stdenv,
  nodejs,
  kulala-core,
  fetchurl,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kulala-fmt";
  version = "3.0.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mistweaverco/kulala-fmt/-/kulala-fmt-${version}.tgz";
    hash = "sha256-dmfn/1k6FXTpuVcCC7qo7y6V9VzOP7Z/iixgcEthZAg=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/kulala-fmt
    cp -r . $out/lib/node_modules/kulala-fmt

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/kulala-fmt \
      --add-flags "$out/lib/node_modules/kulala-fmt/dist/cli.cjs" \
      --set KULALA_CORE_PATH ${kulala-core}/bin/kulala-core

    runHook postInstall
  '';

  meta = {
    description = "Opinionated .http and .rest files linter and formatter";
    homepage = "https://github.com/mistweaverco/kulala-fmt";
    license = lib.licenses.mit;
    mainProgram = "kulala-fmt";
    platforms = lib.platforms.all;
  };
}
