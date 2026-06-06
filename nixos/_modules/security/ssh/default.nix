{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure ssh service options";
    enableAgent = mkEnableOption "add ssh agent";
  };

  config = mkIf moduleConfig.enable {
    services.openssh.enable = true;
    programs.ssh = {
      startAgent = moduleConfig.enableAgent;
    };
  };
}
