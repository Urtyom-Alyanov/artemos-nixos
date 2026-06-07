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
    enable = mkEnableOption "Enable Prism Launcher with custom Java runtimes";
  };

  config = mkIf moduleConfig.enable {
    programs.prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {
        additionalPrograms = [pkgs.ffmpeg];
        jdks = with pkgs; [
          graalvmPackages.graalvm-ce
          zulu8
          zulu11
          zulu17
          zulu21
          zulu25
        ];
      };
    };
  };
}
