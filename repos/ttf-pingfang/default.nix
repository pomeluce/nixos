{
  stdenv,
  fetchurl,
  fontconfig,
  lib,
}:

let
  version = "3.0.1";
  sha256sums = [
    "0215ed14d69e3faecd3754ead14265d488b8fbea891a23ca1a93f7f5bdd02aa5"
    "cf1d3c696c6a73ea550b8f156caa7938ffd88bf5f99a558c71b6862f6be5e003"
    "1246b6a54ef7a0ddf1ce02da76d9ec9fcc03d948b7c6258dbeae93815e427f80"
  ];
  baseUrl = "https://github.com/witt-bit/applePingFangFonts/releases/download/${version}";
in
rec {
  PingFang = stdenv.mkDerivation {
    pname = "pingfang";
    inherit version;
    src = fetchurl {
      url = "${baseUrl}/pingFang-20.0d4e1.tar.gz";
      sha256 = builtins.elemAt sha256sums 0;
    };
    nativeBuildInputs = [ fontconfig ];
    installPhase = ''
      mkdir -p $out/share/fonts/pingFang
      cp -r * $out/share/fonts/pingFang/
    '';
    meta = with lib; {
      description = "Apple 公司苹方字体";
      homepage = "https://developer.apple.com/fonts/";
      license = licenses.unfree;
      maintainers = with maintainers; [ pomeluce ];
    };
  };

  PingFangRelaxed = stdenv.mkDerivation {
    pname = "pingfang-relaxed";
    inherit version;
    src = fetchurl {
      url = "${baseUrl}/pingFangRelaxed-19.0d5e3.tar.gz";
      sha256 = builtins.elemAt sha256sums 1;
    };
    nativeBuildInputs = [ fontconfig ];
    installPhase = ''
      mkdir -p $out/share/fonts/pingFangRelaxed
      cp -r * $out/share/fonts/pingFangRelaxed/
    '';
    meta = with lib; {
      description = "开苹方字体（PingFang Relaxed）";
      homepage = "https://developer.apple.com/fonts/";
      license = licenses.unfree;
      maintainers = with maintainers; [ pomeluce ];
    };
  };

  PingFangUI = stdenv.mkDerivation {
    pname = "pingfang-ui";
    inherit version;
    src = fetchurl {
      url = "${baseUrl}/pingFangUI-20.0d15e3.tar.gz";
      sha256 = builtins.elemAt sha256sums 2;
    };
    nativeBuildInputs = [ fontconfig ];
    installPhase = ''
      mkdir -p $out/share/fonts/pingFangUI
      cp -r * $out/share/fonts/pingFangUI/
    '';
    meta = with lib; {
      description = "苹方 UI 字体（PingFang UI）";
      homepage = "https://developer.apple.com/fonts/";
      license = licenses.unfree;
      maintainers = with maintainers; [ pomeluce ];
    };
  };
}
