{
  inputs,
  config,
  pkgs,
  opts,
  ...
}:
let
  ignisPath = "${opts.devroot}/wsp/akir-shell";
in
{
  imports = [ inputs.ignis.homeManagerModules.default ];
  programs.ignis = {
    enable = true;
    addToPythonEnv = true;
    services = {
      bluetooth.enable = true;
      recorder.enable = true;
      audio.enable = true;
      network.enable = true;
    };
    sass = {
      enable = true;
      useDartSass = true;
    };
    extraPackages = with pkgs.python313Packages; [
      jinja2
      materialyoucolor
      pillow
    ];
  };

  xdg.configFile."ignis".source = config.lib.file.mkOutOfStoreSymlink ignisPath;
}
