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
    enable = mkEnableOption "The standard fonts configuration";
  };

  config = mkIf moduleConfig.enable {
    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-c28b.psf.gz";
      earlySetup = true;
    };

    fonts = {
      fontDir.enable = true;

      packages = with pkgs; [
        fira-code
        nerd-fonts.fira-code
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        corefonts
        vista-fonts
      ];

      fontconfig.defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
          "Arial"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
          "Liberation Serif"
          "Times New Roman"
        ];
        monospace = [
          "FiraCode Nerd Font"
          "FiraCode"
          "Noto Sans Mono"
          "Noto Sans Mono CJK SC"
          "Consolas"
        ];
        emoji = ["Noto Color Emojji"];
      };
    };
  };
}
