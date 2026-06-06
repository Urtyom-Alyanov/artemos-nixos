{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "use lanzaboote modification for systemd-boot as secure boot bootloader";
  };

  config = mkIf moduleConfig.enable {
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        autoReboot = true;
        enable = true;
        # includeChecksumsFromTPM = true;
        includeMicrosoftKeys = true;
      };

      pkiBundle = "/var/lib/sbctl";
    };
  };
}
