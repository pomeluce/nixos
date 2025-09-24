{
  stdenv,
  lib,
  fetchFromGitHub,
  theme ? "mojave", # [forest|mojave|mountain|wave]
  screens ? "1080p", # [1080p|2k|4k]
  type ? "blur", # [window|float|sharp|blur]
  color ? "dark", # [dark|light]
  side ? "left", # [left|right]
  ...
}:
let
  version = "92cdac334cf7bc5c1d68c2fbb266164653b4b502";
in
stdenv.mkDerivation {
  pname = "elegant-theme";
  inherit version;

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Elegant-grub2-themes";
    rev = "${version}";
    hash = "sha256-fbZLWHxnLBrqBrS2MnM2G08HgEM2dmZvitiCERie0Cc=";
  };
  installPhase = ''
    mkdir -p $out/grub/themes

    mkdir -p common
    for box in c e n ne nw s se sw w; do
      touch common/terminal_box_$box.png
    done

    # Run the install script
              bash ./generate.sh \
                --dest $out/grub/themes \
                --theme ${theme} \
                --screen ${screens} \
                --color ${color} \
                --type ${type} \
                --side ${side} \
  '';

  meta = with lib; {
    description = "Elegant grub2 themes for all linux systems";
    homepage = "https://github.com/vinceliuice/Elegant-grub2-themes";
    license = licenses.mit;
    maintainers = with maintainers; [ pomeluce ];
    platforms = platforms.linux;
  };
}
