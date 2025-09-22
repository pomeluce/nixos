{
  config,
  pkgs,
  opts,
  ...
}:
{
  home.packages = with pkgs; [
    (jetbrains.idea-ultimate.override {
      jdk = pkgs.stable.jetbrains.jdk;
    })
  ];

  home.file.".jebrains/idea.vmoptions".text = ''
    ${builtins.readFile "${pkgs.jetbrains.idea-ultimate}/idea-ultimate/bin/idea64.vmoptions"}
    --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
    -javaagent:${opts.devroot}/env/agent/netfilter/ja-netfilter.jar=jetbrains
  '';

  home.sessionVariables = {
    IDEA_VM_OPTIONS = "${config.home.homeDirectory}/.jebrains/idea.vmoptions";
  };
}
