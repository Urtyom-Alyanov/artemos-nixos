{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "activate kalde";
  };

  config = mkIf moduleConfig.enable {
    services.desktopManager.plasma6 = {
      enableQt5Integration = true;
      enable = true;
    };
  };
}
