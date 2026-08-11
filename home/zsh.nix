{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
  };

  programs.akzsh = {
    enable = true;
    extraPackages = with pkgs; [
      lsd
      jq
    ];
    promptStyle = config.mo.programs.zsh.promptStyle;
  };
}
