{
  lib,
  gcc,
  clang,
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

  # 同时构建 CLI 和 runtime staticlib
  cargoBuildFlags = [
    "-p"
    "perry"
    "-p"
    "perry-runtime"
  ];

  cargoTestFlags = [
    "-p"
    "perry"
  ];

  # Perry 在运行 perry compile 时还需要 C 工具链/链接器
  postInstall = ''
    mkdir -p $out/lib
    runtime_lib="$(find target -name libperry_runtime.a -type f | head -n 1)"
    if [ -z "$runtime_lib" ]; then
      echo "libperry_runtime.a not found"
      find target -maxdepth 4 -type f | sort
      exit 1
    fi
    install -Dm444 "$runtime_lib" "$out/lib/libperry_runtime.a"

    wrapProgram $out/bin/perry --prefix PATH : ${
      lib.makeBinPath [
        gcc
        clang
        binutils
      ]
    } \
    --set-default PERRY_LLVM_CLANG ${clang}/bin/clang \
    --set-default PERRY_RUNTIME_DIR $out/lib
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
