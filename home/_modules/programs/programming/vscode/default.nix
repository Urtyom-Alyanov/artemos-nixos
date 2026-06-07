{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "use vscode (or fork) for editor";
    reporterId = mkOption {
      type = types.nullOr types.str;
      description = "Reports of bugs";
    };
    aiEnable = mkEnableOption "Enable AI assistance (e.g. Copilot)";
    aiProvider = mkOption {
      type = types.nullOr types.str;
      description = "AI provider identifier (e.g. github.copilot)";
    };
    aiEnableChat = mkOption {
      type = types.bool;
      default = true;
      description = "Enable AI chat features (if supported by provider)";
    };
  };

  config = mkIf moduleConfig.enable {
    programs.vscodium = {
      enable = true;

      argvSettings = {
        locale = "ru";
        password-store = "gnome-libsecret";
        enable-crash-reporter = moduleConfig.reporterId != null;
        crash-reporter-id = moduleConfig.reporterId;
      };

      profiles.default = {
        userSettings = {
          # Будет настроено с помощью Stylix
          "editor.fontFamily" = lib.mkDefault "'FiraCode Nerd Font'";
          "editor.fontSize" = lib.mkDefault 13;
          "editor.fontWeight" = lib.mkDefault "500";
          "workbench.preferredDarkColorTheme" = lib.mkDefault "Catppuccin Mocha";
          "workbench.iconTheme" = lib.mkDefault "catppuccin-mocha";

          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.smoothScrolling" = true;
          "editor.cursorBlinking" = "expand";
          "editor.fontLigatures" = true;
          "workbench.list.smoothScrolling" = true;
          "terminal.integrated.smoothScrolling" = true;

          "terminal.integrated.cursorBlinking" = true;
          "terminal.integrated.fontLigatures.enabled" = true;
          "terminal.integrated.gpuAcceleration" = "on";
          "terminal.integrated.cursorStyle" = "line";

          "editor.tabSize" = 2;
          "editor.wordWrap" = "on";
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
          "files.trimTrailingWhitespace" = true;
          "files.insertFinalNewline" = true;
          "editor.minimap.enabled" = true;

          "terminal.integrated.scrollback" = 10000;
          "github.copilot.enable" = moduleConfig.aiEnable;
          "github.copilot.chat.enable" = moduleConfig.aiEnableChat;
        };

        extensions = with pkgs.vscode-extensions;
          [
            # Language
            ms-ceintl.vscode-language-pack-ru

            # Nix
            jnoortheen.nix-ide
            arrterian.nix-env-selector

            # Shell
            bmalehorn.vscode-fish
            ms-vscode.powershell
            mads-hartmann.bash-ide-vscode

            # Configs & Docs
            mkhl.direnv
            tamasfe.even-better-toml
            bierner.markdown-mermaid
            github.vscode-github-actions
            ms-azuretools.vscode-containers
          ]
          ++ [
            # CSharp
            ms-dotnettools.csdevkit
            ms-dotnettools.csharp
            ms-dotnettools.vscode-dotnet-runtime
          ]
          ++ [
            # BLAZING
            rust-lang.rust-analyzer
          ]
          ++ (
            if moduleConfig.aiEnable
            then
              (
                if moduleConfig.aiEnableChat
                then [
                  # GH Copilot
                  github.copilot
                  github.copilot-chat
                ]
                else [github.copilot]
              )
            else []
          );
      };
    };
  };
}
