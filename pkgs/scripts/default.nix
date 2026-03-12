pkgs: {
  screenshot = pkgs.writers.writeNuBin "screenshot" {
    makeWrapperArgs = with pkgs; [
      "--prefix PATH : ${
        lib.makeBinPath [
          libnotify
          slurp
          wayshot
          swappy
          wl-clipboard
        ]
      }"
    ];
  } (builtins.readFile ./screenshot.nu);

  ccs = pkgs.writers.writeNuBin "ccs" { makeWrapperArgs = [ ]; } (builtins.readFile ./ccs.nu);
}
