{ lib, config, ... }:
let
  keys = import ./keybindings.nix;
in
{
  config = lib.mkIf config.mo.desktop.enable {
    programs.vscode = {
      enable = config.mo.programs.vscode.enable;
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

          /* 其他扩展配置 */ "npm.packageManager" = "pnpm";
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

          "vim.normalModeKeyBindingsNonRecursive" = keys.normal;
          "vim.visualModeKeyBindingsNonRecursive" = keys.visual;
          "vim.insertModeKeyBindings" = keys.insert;

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
  };
}
