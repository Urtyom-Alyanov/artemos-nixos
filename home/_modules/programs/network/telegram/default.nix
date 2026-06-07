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
    enable = mkEnableOption "Install Telegram client using AyuGram Desktop";
    autostart = mkEnableOption "Add AyuGram to XDG autostart on login";
  };

  config = mkIf moduleConfig.enable {
    home.packages = with pkgs; [ayugram-desktop];

    homeModules.xdg.autostart = mkIf moduleConfig.autostart {
      enable = true;
      entries = {
        tdesktop = {
          exec = "${pkgs.ayugram-desktop}/bin/AyuGram";
          flags = "-autostart";
        };
      };
    };
  };
}
