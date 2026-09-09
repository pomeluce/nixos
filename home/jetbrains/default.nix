{
  lib,
  config,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.mo.desktop.enable {
    home.packages = with pkgs; [
      jetbrains.datagrip
    ];

    home.file.".jebrains/datagrip.vmoptions".text = ''
      ${builtins.readFile "${pkgs.jetbrains.datagrip}/datagrip/bin/datagrip64.vmoptions"}
      -javaagent:${./netfilter/ja-netfilter.jar}
    '';

    home.sessionVariables = {
      DATAGRIP_VM_OPTIONS = "${config.home.homeDirectory}/.jebrains/datagrip.vmoptions";
    };

    home.file.".ideavimrc".source = ./ideavimrc;
  };
}
