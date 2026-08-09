{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
  };

  programs.akiron-zsh = {
    enable = true;
    extraPackages = with pkgs; [
      lsd
      jq
    ];
    promptStyle = "segments";
  };
}
