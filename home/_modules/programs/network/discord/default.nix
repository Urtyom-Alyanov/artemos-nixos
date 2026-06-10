{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  persistEnable = config.homeModules.persistence.enable;
in {
  options = mkOptions {
    enable = mkEnableOption "Enable nixcord with Equibop and custom theming";
    autostart = mkEnableOption "Add Equibop to XDG autostart on login";
  };

  config = mkIf moduleConfig.enable {
    programs.nixcord = {
      enable = true;

      discord.enable = false;
      equibop.enable = true;
      equibop.autoscroll.enable = true;

      quickCss = ''        /*
              @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");
              */'';

      config = {
        useQuickCss = true;
        themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"];
        frameless = true;

        plugins = {
          fakeNitro.enable = true;
          equibopStreamFixes.enable = true;
          showHiddenChannels.enable = true;
          volumeBooster.enable = true;
        };
      };
    };

    homeModules.xdg.autostart = mkIf moduleConfig.autostart {
      enable = true;
      entries = {
        discord = {
          exec = "${pkgs.equibop}/bin/equibop";
          flags = "--start-minimized";
        };
      };
    };

    homeModules.persistence = mkIf persistEnable {
      dirs = [
        ".config/equibop"
      ];
    };
  };
}
