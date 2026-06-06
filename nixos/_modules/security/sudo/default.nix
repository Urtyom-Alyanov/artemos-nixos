{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure sudo";
    dontAssertWheelPassword = mkEnableOption "disable password requirement for wheel group";
  };

  config = mkIf moduleConfig.enable {
    security.sudo-rs = {
      enable = true;
      wheelNeedsPassword = !moduleConfig.dontAssertWheelPassword;
      execWheelOnly = true;
    };
  };
}
