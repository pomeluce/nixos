{ pkgs, config, ... }:
let
  model_path = "${config.mo.devroot}/wsp/nixos/home/claude/models.json";
in
{
  programs.claude-code = {
    enable = true;
    # package = pkgs.unsmall.claude-code;
  };

  home.packages = with pkgs; [ npkgs.scripts.ccs ];
  home.file.".claude/models.json".source = config.lib.file.mkOutOfStoreSymlink model_path;
}
