{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
  };

  programs.azimfw = {
    enable = true;
    extraPackages = with pkgs; [
      lsd
      jq
    ];
    promptStyle = "segments";
  };
}
