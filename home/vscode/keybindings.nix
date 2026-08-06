{
  normal = [
    {
      "before" = [ "s" ];
      "after" = [ "<nop>" ];
    }
    {
      "before" = [ ";" ];
      "after" = [ ":" ];
    }
    {
      "before" = [ "S" ];
      "commands" = [ "workbench.action.files.save" ];
    }
    {
      "before" = [ "Q" ];
      "commands" = [ "workbench.action.closeWindow" ];
    }
    {
      "before" = [ "<M-a>" ];
      "after" = [
        "g"
        "g"
        "v"
        "G"
      ];
    }
    {
      "before" = [ "<M-s>" ];
      "after" = [
        "v"
        "i"
        "{"
      ];
    }
    {
      "before" = [
        "s"
        "v"
      ];
      "commands" = [ ":vs" ];
    }
    {
      "before" = [
        "s"
        "p"
      ];
      "commands" = [ ":sp" ];
    }
    {
      "before" = [
        "s"
        "c"
      ];
      "commands" = [ ":close" ];
    }
    {
      "before" = [
        "s"
        "o"
      ];
      "commands" = [ ":only" ];
    }
    {
      "before" = [
        "s"
        "s"
      ];
      "commands" = [ ":bn" ];
    }
    {
      "before" = [ "<C-h>" ];
      "after" = [
        "<C-w>"
        "h"
      ];
    }
    {
      "before" = [ "<C-l>" ];
      "after" = [
        "<C-w>"
        "l"
      ];
    }
    {
      "before" = [ "<C-j>" ];
      "after" = [
        "<C-w>"
        "j"
      ];
    }
    {
      "before" = [ "<C-k>" ];
      "after" = [
        "<C-w>"
        "k"
      ];
    }
    {
      "before" = [ "<C-Space>" ];
      "after" = [
        "<C-w>"
        "w"
      ];
    }
    {
      "before" = [
        "s"
        "="
      ];
      "after" = [
        "<C-w>"
        "="
      ];
    }
    {
      "before" = [
        "s"
        "."
      ];
      "commands" = [ ":vertical res +10" ];
    }
    {
      "before" = [
        "s"
        ","
      ];
      "commands" = [ ":vertical res -20" ];
    }
    {
      "before" = [
        "s"
        "j"
      ];
      "commands" = [ ":res +10" ];
    }
    {
      "before" = [
        "s"
        "k"
      ];
      "commands" = [ ":res -10" ];
    }
    {
      "before" = [
        "<leader>"
        "c"
      ];
      "commands" = [ "workbench.action.closeActiveEditor" ];
    }
    {
      "before" = [
        "g"
        "e"
      ];
      "commands" = [ "editor.action.marker.next" ];
    }
    {
      "before" = [
        "g"
        "t"
      ];
      "commands" = [ "testing.goToNextMessage" ];
    }
    {
      "before" = [
        "g"
        "d"
      ];
      "commands" = [ "editor.action.goToDeclaration" ];
    }
    {
      "before" = [
        "g"
        "i"
      ];
      "commands" = [ "editor.action.goToImplementation" ];
    }
    {
      "before" = [
        "g"
        "a"
      ];
      "after" = [
        "'"
        "."
      ];
    }
    {
      "before" = [
        "z"
        "z"
      ];
      "commands" = [ "editor.toggleFold" ];
    }
    {
      "before" = [
        "<leader>"
        "z"
        "z"
      ];
      "commands" = [ "editor.foldAll" ];
    }
    {
      "before" = [
        "<leader>"
        "z"
        "c"
      ];
      "commands" = [ "editor.unfoldAll" ];
    }
    {
      "before" = [
        "<leader>"
        "f"
        "t"
      ];
      "commands" = [ "workbench.view.search" ];
    }
    {
      "before" = [
        "<leader>"
        "f"
        "f"
      ];
      "commands" = [ "workbench.action.quickOpen" ];
    }
    {
      "before" = [
        "<leader>"
        "f"
        "w"
      ];
      "commands" = [ "actions.find" ];
    }
    {
      "before" = [
        "<leader>"
        "f"
        "h"
      ];
      "commands" = [ "workbench.action.openPreviousEditorFromHistory" ];
    }
    {
      "before" = [
        "<leader>"
        "f"
        "p"
      ];
      "commands" = [ "workbench.action.openRecent" ];
    }
    {
      "before" = [
        "<leader>"
        "r"
        "t"
      ];
      "commands" = [ "editor.action.startFindReplaceAction" ];
    }
    {
      "before" = [
        "<leader>"
        ";"
      ];
      "after" = [
        "A"
        ";"
        "<esc>"
      ];
    }
    {
      "before" = [ "0" ];
      "after" = [ "%" ];
    }
    {
      "before" = [
        "<leader>"
        "s"
        "s"
      ];
      "commands" = [ "workbench.action.quickOpenView" ];
    }
    {
      "before" = [
        "<leader>"
        "f"
        "m"
      ];
      "commands" = [ "editor.action.formatDocument" ];
    }
    {
      "before" = [
        "<leader>"
        "n"
        "h"
      ];
      "commands" = [ ":nohl" ];
    }
    {
      "before" = [ "<F5>" ];
      "commands" = [ "code-runner.run" ];
    }
    {
      "before" = [ "T" ];
      "commands" = [ "workbench.view.explorer" ];
    }
    {
      "before" = [ "C" ];
      "commands" = [ "git.viewLineHistory" ];
    }
    {
      "before" = [
        "<leader>"
        "/"
      ];
      "commands" = [ "editor.action.commentLine" ];
    }
    {
      "before" = [
        "<leader>"
        "<leader>"
        "/"
      ];
      "commands" = [ "editor.action.blockComment" ];
    }
    {
      "before" = [ "<C-t>" ];
      "commands" = [ "workbench.action.terminal.toggleTerminal" ];
    }
    {
      "before" = [ "u" ];
      "commands" = [ "undo" ];
    }
    {
      "before" = [ "<C-r>" ];
      "commands" = [ "redo" ];
    }
    {
      "before" = [
        "<leader>"
        "t"
        "r"
      ];
      "commands" = [ "editor.action.showHover" ];
    }
  ];

  visual = [
    {
      "before" = [ ";" ];
      "after" = [ ":" ];
    }
    {
      "before" = [ "p" ];
      "after" = [
        "\""
        "_"
        "d"
        "h"
        "p"
      ];
    }
    {
      "before" = [ "<" ];
      "after" = [
        "<"
        "g"
        "v"
      ];
    }
    {
      "before" = [ ">" ];
      "after" = [
        ">"
        "g"
        "v"
      ];
    }
    {
      "before" = [ "<S-tab>" ];
      "after" = [
        "<"
        "g"
        "v"
      ];
    }
    {
      "before" = [ "<tab>" ];
      "after" = [
        ">"
        "g"
        "v"
      ];
    }
    {
      "before" = [ "0" ];
      "after" = [ "%" ];
    }
    {
      "before" = [
        "t"
        "h"
      ];
      "commands" = [ "extension.varTranslation.camelCase" ];
    }
    {
      "before" = [
        "<leader>"
        "t"
        "h"
      ];
      "commands" = [ "extension.varTranslation.snakeCase" ];
    }
    {
      "before" = [ "v" ];
      "commands" = [ "expand_region" ];
    }
    {
      "before" = [ "V" ];
      "commands" = [ "undo_expand_region" ];
    }
    {
      "before" = [
        "<leader>"
        "f"
        "m"
      ];
      "commands" = [ "editor.action.formatDocument" ];
    }
    {
      "before" = [
        "<leader>"
        "/"
      ];
      "commands" = [ "editor.action.commentLine" ];
    }
    {
      "before" = [
        "<leader>"
        "<leader>"
        "/"
      ];
      "commands" = [ "editor.action.blockComment" ];
    }
    {
      "before" = [
        "<leader>"
        "t"
        "r"
      ];
      "commands" = [ "editor.action.showHover" ];
    }
  ];

  insert = [
    {
      "before" = [
        "j"
        "k"
      ];
      "after" = [ "<esc>" ];
    }
    {
      "before" = [ "<F5>" ];
      "commands" = [ "code-runner.run" ];
    }
  ];
}
