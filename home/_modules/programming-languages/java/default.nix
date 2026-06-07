{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  persistEnable = config.homeModules.persistence.enable or false;
in {
  options = mkOptions {
    enable = mkEnableOption "Enable Java tooling (JDK (Temurin), maven, gradle, kotlin)";
  };

  config = mkIf moduleConfig.enable {
    home.packages = with pkgs; [
      temurin-bin-25
      temurin-bin-21
      temurin-bin-17
      temurin-bin-11
      temurin-bin-8

      maven
      gradle
      kotlin
    ];

    homeModules.persistence = mkIf persistEnable {
      dirs = [
        "${config.home.homeDirectory}/.m2"
        "${config.home.homeDirectory}/.gradle"
        "${config.home.homeDirectory}/.konan"
      ];
    };
  };
}
