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
    enable = mkEnableOption "configure steam";
    useMillenium = mkEnableOption "use millenium patchs";
  };

  config = mkIf moduleConfig.enable {
    programs.steam = {
      enable = true;
      package =
        if moduleConfig.useMillenium
        then pkgs.millennium-steam
        else pkgs.steam;

      gamescopeSession.enable = true;

      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };
  };
}
