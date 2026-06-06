{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "activate kalde login manager";
  };

  config = mkIf moduleConfig.enable {
    services.displayManager.plasma-login-manager = {
      enable = true;
    };
  };
}
