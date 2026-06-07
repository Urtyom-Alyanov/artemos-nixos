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
    enable = mkEnableOption "Enable C# tooling (dotnet SDK, omnisharp)";
  };

  config = mkIf moduleConfig.enable {
    home.packages = [pkgs.dotnet-sdk_10 pkgs.omnisharp-roslyn];

    home.sessionVariables = {
      DOTNET_ROOT = "/etc/profiles/per-user/artemos/share/dotnet";
    };

    homeModules.persistence = mkIf persistEnable {
      dirs = [
        "${config.home.homeDirectory}/.dotnet"
        "${config.home.homeDirectory}/.nuget"
      ];
    };
  };
}
