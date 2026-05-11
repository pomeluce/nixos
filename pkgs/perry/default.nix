{
  lib,
  clang,
  stdenv,
  binutils,
  pkg-config,
  makeWrapper,
  rustPlatform,
  fetchFromGitHub,

  gtk4,
  libshumate,
  gst_all_1,
  ...
}:

let
  version = "0.5.585";
  rustTarget =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x86_64-unknown-linux-gnu"
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      "aarch64-unknown-linux-gnu"
    else
      throw "perry: unsupported platform ${stdenv.hostPlatform.system}";

  gtkBuildInputs = [
    gtk4
    libshumate
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];
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

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = gtkBuildInputs;

  # 同时构建 CLI 和 runtime staticlib
  cargoBuildFlags = [
    "--target"
    rustTarget
    "-p"
    "perry"
    "-p"
    "perry-runtime"
    "-p"
    "perry-stdlib"
    "-p"
    "perry-ui-gtk4"
  ];

  # Perry 在运行 perry compile 时还需要 C 工具链/链接器
  postInstall = ''
    release_dir="target/${rustTarget}/release"
    mkdir -p "$out/lib/perry"

    install_static_lib() {
      local name="$1"
      local path="$release_dir/$name"

      if [ ! -f "$path" ]; then
        echo "$name not found at $path"
        echo "Available files:"
        find target -maxdepth 6 -type f | sort
        exit 1
      fi

      install -Dm444 "$path" "$out/lib/perry/$name"
    }

    install_static_lib libperry_runtime.a
    install_static_lib libperry_stdlib.a
    install_static_lib libperry_ui_gtk4.a

    wrapProgram $out/bin/perry --prefix PATH : ${
      lib.makeBinPath [
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
