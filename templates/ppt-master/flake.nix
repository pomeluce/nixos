{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        let
          python = pkgs.python3.withPackages (
            pythonPackages: with pythonPackages; [
              beautifulsoup4
              curl-cffi
              edge-tts
              ebooklib
              flask
              google-genai
              mammoth
              markdownify
              nbconvert
              numpy
              openpyxl
              pillow
              pymupdf
              python-pptx
              pyyaml
              requests
              skia-pathops
              uharfbuzz
              xlsxwriter
            ]
          );
        in
        {
          devShells.default = pkgs.mkShellNoCC {
            packages = [ python ];
          };
        };
    };
}
