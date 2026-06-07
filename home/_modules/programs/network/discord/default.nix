{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Enable nixcord with Equibop and custom theming";
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
  };
}
