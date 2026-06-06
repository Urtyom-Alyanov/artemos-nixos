{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "use waydroid for android apps";
  };

  config = mkIf moduleConfig.enable {
    virtualisation.waydroid.enable = true;
  };
}
