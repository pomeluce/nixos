{ lib, config, ... }:
{
  config = lib.mkIf config.mo.desktop.enable {
    programs.vscode = {
      enable = true;
      profiles.default = {
        userSettings = {
          # editor 配置
          "editor.tokenColorCustomizations" = { };
          "editor.mouseWheelZoom" = true;
          "editor.tabSize" = 2;
          "editor.hover.delay" = 500;
          "editor.inlineSuggest.enabled" = true;
          "editor.linkedEditing" = true;
          "editor.guides.bracketPairs" = true;
          "editor.minimap.enabled" = false;
          "editor.stickyScroll.enabled" = true;
          "editor.lineHeight" = 1.8;
          "editor.cursorSurroundingLines" = 50;
          "editor.lineNumbers" = "relative";

          # files 配置
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 100;
          "explorer.confirmDelete" = false;

          # workbench 配置
          "workbench.editor.wrapTabs" = true;
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.editorAssociations" = {
            "*.dll" = "default";
          };
          "workbench.startupEditor" = "none";
          "workbench.layoutControl.enabled" = false;
          "window.menuBarVisibility" = "toggle";

          # Catppuccin 主题覆盖
          "catppuccin.colorOverrides" = {
            "frappe" = {
              "rosewater" = "#ea6962";
              "flamingo" = "#ea6962";
              "red" = "#ea6962";
              "maroon" = "#ea6962";
              "pink" = "#d3869b";
              "mauve" = "#d3869b";
              "peach" = "#e78a4e";
              "yellow" = "#d8a657";
              "green" = "#a9b665";
              "teal" = "#89b482";
              "sky" = "#89b482";
              "sapphire" = "#89b482";
              "blue" = "#7daea3";
              "lavender" = "#7daea3";
              "text" = "#f5f5f5";
              "subtext1" = "#ebebeb";
              "subtext0" = "#e0e0e0";
              "overlay2" = "#cccccc";
              "overlay1" = "#b3b3b3";
              "overlay0" = "#999999";
              "surface2" = "#424242";
              "surface1" = "#3d3d3d";
              "surface0" = "#383838";
              "base" = "#202020";
              "mantle" = "#262626";
              "crust" = "#2b2b2b";
            };
            "mocha" = {
              "rosewater" = "#d3c6aa";
              "flamingo" = "#f07173";
              "pink" = "#d87595";
              "mauve" = "#d87595";
              "red" = "#f07173";
              "maroon" = "#63b4ed";
              "peach" = "#e69875";
              "yellow" = "#e2ae6a";
              "green" = "#99c983";
              "teal" = "#60a673";
              "sky" = "#78bdb4";
              "sapphire" = "#78bdb4";
              "blue" = "#78bdb4";
              "lavender" = "#9d94d4";
              "text" = "#f5f5f5";
              "subtext1" = "#ebebeb";
              "subtext0" = "#e0e0e0";
              "overlay2" = "#cccccc";
              "overlay1" = "#b3b3b3";
              "overlay0" = "#999999";
              "surface2" = "#424242";
              "surface1" = "#3d3d3d";
              "surface0" = "#383838";
              "base" = "#202020";
              "mantle" = "#262626";
              "crust" = "#2b2b2b";
            };
          };

          /* 其他扩展配置 */
          "npm.packageManager" = "pnpm";
          "extensions.autoUpdate" = "onlyEnabledExtensions";
          "liveServer.settings.donotShowInfoMsg" = true;
          "liveServer.settings.donotVerifyTags" = true;
          "code-runner.runInTerminal" = true;
          "cSpell.userWords" = [
            "Gitee"
            "jetbrains"
            "Monokai"
            "pacman"
          ];
          "cSpell.ignorePaths" = [
            "package-lock.json"
            "node_modules"
            "vscode-extension"
            ".git/objects"
            ".vscode"
            ".vscode-insiders"
            "settings.json"
          ];
          "markdown-preview-enhanced.previewTheme" = "vue.css";
          "material-icon-theme.activeIconPack" = "none";
          "tabout.disableByDefault" = true;
          "security.allowedUNCHosts" = [ "wsl.localhost" ];
          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };

          # Vim 插件配置
          "vim.showcmd" = true;
          "vim.useSystemClipboard" = true;
          "vim.hlsearch" = true;
          "vim.incsearch" = true;
          "vim.inccommand" = "append";
          "vim.ignorecase" = true;
          "vim.smartcase" = true;
          "vim.timeout" = 500;
          "vim.whichwrap" = "<,>,[,],h,l";
          "vim.autoindent" = true;
          "vim.leader" = "<space>";
          "vim.easymotion" = true;
          "vim.history" = 100;
          "vim.useCtrlKeys" = true;
          "vim.handleKeys" = {
            "<C-t>" = false;
          };
          "vim.surround" = true;

          "vim.normalModeKeyBindingsNonRecursive" = [
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
          "vim.visualModeKeyBindingsNonRecursive" = [
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
          "vim.insertModeKeyBindings" = [
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

          # Prettier & 格式化程序
          "[vue]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[jsonc]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[html]" = {
            "editor.defaultFormatter" = "vscode.html-language-features";
          };
          "[scss]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          "prettier.arrowParens" = "avoid";
          "prettier.bracketSameLine" = false;
          "prettier.bracketSpacing" = true;
          "prettier.embeddedLanguageFormatting" = "auto";
          "prettier.endOfLine" = "lf";
          "prettier.htmlWhitespaceSensitivity" = "strict";
          "prettier.insertPragma" = false;
          "prettier.jsxSingleQuote" = false;
          "prettier.printWidth" = 180;
          "prettier.proseWrap" = "never";
          "prettier.quoteProps" = "as-needed";
          "prettier.requirePragma" = false;
          "prettier.semi" = true;
          "prettier.singleQuote" = true;
          "prettier.tabWidth" = 2;
          "prettier.trailingComma" = "all";
          "prettier.useTabs" = false;
          "prettier.vueIndentScriptAndStyle" = false;
          "prettier.singleAttributePerLine" = false;

          "css.validate" = false;
          "scss.validate" = false;
          "less.validate" = false;
        };
      };
    };

    stylix.targets.vscode = {
      enable = true;
      fonts.override = {
        fontFamily = "Maple Mono Normal NL NF, CaskaydiaMono Nerd Font Mono, 'PingFang SC', monospace";
        fontSize = 18;
      };
    };
  };
}
