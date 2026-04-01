{
  lib,
  config,
  pkgs,
  ...
}:
let
  mo = config.mo;
  ivc_path = "${mo.devroot}/wsp/nixos/home/jetbrains/ideavimrc";
in
{

  config = lib.mkIf mo.desktop.enable {
    home.packages = with pkgs; [
      jetbrains.idea
      # (jetbrains.idea.override {
      #   forceWayland = true; # fixed cursor theme
      # })
    ];

    home.file.".jebrains/idea.vmoptions".text = ''
      ${builtins.readFile "${pkgs.jetbrains.idea}/idea/bin/idea64.vmoptions"}
      -javaagent:${mo.devroot}/env/agent/netfilter/ja-netfilter.jar
    '';

    home.sessionVariables = {
      IDEA_VM_OPTIONS = "${config.home.homeDirectory}/.jebrains/idea.vmoptions";
    };

    home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink ivc_path;
  };
}
