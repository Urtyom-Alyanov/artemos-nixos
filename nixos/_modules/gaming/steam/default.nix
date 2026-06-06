{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure steam";
  };

  config = mkIf moduleConfig.enable {
    programs.steam = {
      enable = true;

      gamescopeSession.enable = true;

      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };
  };
}
