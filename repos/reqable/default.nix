{
  stdenv,
  lib,
  fetchurl,
  bsdtar,
  binutils,

  julia,
  libdbusmenu-gtk3,
  gdk-pixbuf,
  cairo,
  at-spi2-atk,
  harfbuzz,
  glib,
  pango,
  libuuid,
  libgcrypt,
  xz,
  lz4,
  libgpg-error,
  libepoxy,
  fontconfig,
  gtk3,
  nss,
  nspr,
}:

stdenv.mkDerivation rec {
  pname = "reqable";
  version = "2.33.12";

  src = fetchurl {
    url = "https://github.com/reqable/reqable-app/releases/download/${version}/reqable-app-linux-x86_64.deb";
    sha256 = "13hsgsczzj2sj59nj4291kf5si2p34l5pkqxjrzkjink9hjxw89c";
  };

  base = ./.;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    binutils
    bsdtar
  ];

  buildInputs = [
    julia
    libdbusmenu-gtk3
    gdk-pixbuf
    cairo
    at-spi2-atk
    harfbuzz
    glib
    pango
    libuuid
    libgcrypt
    xz
    lz4
    libgpg-error
    libepoxy
    fontconfig
    gtk3
    nss
    nspr
  ];

  installPhase = ''
    mkdir -p $out

    tmpdir=$(mktemp -d)
    pushd "$tmpdir"
    ar x "${src}"

    dataFile=$(ls data.tar.* 2>/dev/null || true)
    if [ -z "$dataFile" ]; then
      echo "Error: 未找到 data.tar.*"
      exit 1
    fi

    mkdir -p extractdir
    bsdtar -xf "$dataFile" -C extractdir

    install -Dm755 "${base}/reqable.sh" "$out/bin/reqable"
    substituteInPlace "$out/bin/reqable" \
      --replace "@appname@" "reqable" \
      --replace "@runname@" "reqable"

    if [ -d extractdir/usr/share/reqable ]; then
      mkdir -p $out/lib/reqable
      cp -Pr extractdir/usr/share/reqable/* $out/lib/reqable/
    fi

    if [ -f extractdir/usr/share/applications/reqable.desktop ]; then
      mkdir -p $out/share/applications
      cp -p extractdir/usr/share/applications/reqable.desktop $out/share/applications/
      substituteInPlace $out/share/applications/reqable.desktop \
        --replace "Exec=/usr/bin/reqable" "Exec=$out/bin/reqable"
    fi
    if [ -f extractdir/usr/share/pixmaps/reqable.png ]; then
      mkdir -p $out/share/pixmaps
      cp -p extractdir/usr/share/pixmaps/reqable.png $out/share/pixmaps/
    fi

    if [ -f "${base}/LICENSE.html" ]; then
      mkdir -p $out/share/licenses/reqable
      cp -p "${base}/LICENSE.html" $out/share/licenses/reqable/
    fi

    popd
    rm -rf "$tmpdir"
  '';

  meta = with lib; {
    description = "Reqable: A cross platform professional HTTP development and Debugger that supports HTTP1, HTTP2, and HTTP3 (QUIC) protocols (预编译版本)";
    homepage = "https://reqable.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ pomeluce ];
    platforms = platforms.linux;
  };
}
