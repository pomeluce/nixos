{
  lib,
  gcc,
  binutils,
  makeWrapper,
  rustPlatform,
  fetchFromGitHub,
  ...
}:

let
  version = "0.5.585";
in
rustPlatform.buildRustPackage {
  pname = "perry";
  inherit version;

  src = fetchFromGitHub {
    owner = "PerryTS";
    repo = "perry";
    rev = "v${version}";
    # hash = lib.fakeHash;
    hash = "sha256-zZEL9EiOmbSr7ObBJxxHh9SGd4cyC8hZraXqmZUgUUU=";
  };

  # cargoHash = lib.fakeHash;
  cargoHash = "sha256-gqXTrgIzI38Axt4sunAE6R4bcl2OW1rRe7ljGUOaNg0=";

  nativeBuildInputs = [ makeWrapper ];

  # workspace 里有很多 crate, 明确只构建 CLI 包
  cargoBuildFlags = [
    "-p"
    "perry"
  ];

  cargoTestFlags = [
    "-p"
    "perry"
  ];

  # Perry 在运行 perry compile 时还需要 C 工具链/链接器
  postInstall = ''
    wrapProgram $out/bin/perry --prefix PATH:${
      lib.makeBinPath [
        gcc
        binutils
      ]
    }
  '';

  doCheck = false;

  meta = with lib; {
    description = "Native TypeScript compiler written in Rust";
    homepage = "https://github.com/PerryTS/perry";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "perry";
    platforms = platforms.linux;
  };
}
