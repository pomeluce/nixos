{
  lib,
  config,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.mo.desktop.enable {
    home.packages = with pkgs; [
      jetbrains.idea
      # (jetbrains.idea.override {
      #   forceWayland = true; # fixed cursor theme
      # })
    ];

    home.file.".jebrains/idea.vmoptions".text = ''
      ${builtins.readFile "${pkgs.jetbrains.idea}/idea/bin/idea64.vmoptions"}
      -javaagent:${./netfilter/ja-netfilter.jar}
    '';

    home.sessionVariables = {
      IDEA_VM_OPTIONS = "${config.home.homeDirectory}/.jebrains/idea.vmoptions";
    };

    home.file.".ideavimrc".source = ./ideavimrc;
  };
}
