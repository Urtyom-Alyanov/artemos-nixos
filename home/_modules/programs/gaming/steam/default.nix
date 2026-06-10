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
    enable = mkEnableOption "Enable Steam package and autostart support";
    autostart = mkEnableOption "Add Steam to XDG autostart on login";
  };

  config = mkIf moduleConfig.enable {
    home.packages = [pkgs.steam];

    homeModules.xdg.autostart = mkIf moduleConfig.autostart {
      enable = true;
      entries = {
        steam = {
          exec = "${pkgs.steam}/bin/steam";
          flags = "-silent";
        };
      };
    };

    homeModules.persistence = mkIf persistEnable {
      dirs = [
        ".steam"
      ];
    };
  };
}
