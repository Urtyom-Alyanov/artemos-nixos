{
  moduleConfig,
  mkOptions,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Activate printing service";
    avahiService = mkEnableOption "Use the Avahi service";
    saneService = mkEnableOption "Use the SANE service";
  };

  config = mkIf moduleConfig.enable {
    services.printing = {
      enable = true;
      listenAddresses = ["*:631"];
      allowFrom = ["all"];
      browsing = true;
      defaultShared = true;
    };

    hardware.sane.enable = moduleConfig.saneService;

    services.avahi = {
      enable = moduleConfig.avahiService;
      nssmdns4 = true;
    };
  };
}
