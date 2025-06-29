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
  emojiVersion = "18.4";
in
rec {
  ttf-pingfang = stdenv.mkDerivation {
    pname = "ttf-pingfang";
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

  ttf-pingfang-relaxed = stdenv.mkDerivation {
    pname = "ttf-pingfang-relaxed";
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

  ttf-pingfang-ui = stdenv.mkDerivation {
    pname = "ttf-pingfang-ui";
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
      description = "苹方 UI 字体(PingFang UI)";
      homepage = "https://developer.apple.com/fonts/";
      license = licenses.unfree;
      maintainers = with maintainers; [ pomeluce ];
    };
  };

  ttf-pingfang-emoji = stdenv.mkDerivation {
    pname = "ttf-pingfang-emoji";
    version = emojiVersion;
    src = fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v${emojiVersion}/AppleColorEmoji.ttf";
      sha256 = "1ggahpw54rjpxirjbyarwd5gvvg1hi08zw4c1nab8dqls5xhgzd4";
    };
    nativeBuildInputs = [ fontconfig ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/share/fonts/apple-color-emoji
      cp -r $src $out/share/fonts/apple-color-emoji/AppleColorEmoji.ttf

      # Install the fontconfig configuration
      mkdir -p $out/etc/fonts/conf.d
      cp -r ${./75-apple-color-emoji.conf} $out/etc/fonts/conf.d/
    '';
    meta = with lib; {
      description = "Apple Color Emoji is a color typeface used by iOS and macOS to display emoji";
      homepage = "https://github.com/samuelngs/apple-emoji-linux";
      license = licenses.unfree;
      maintainers = with maintainers; [ pomeluce ];
    };
  };

}
