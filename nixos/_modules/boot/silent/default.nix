{ mkOptions, moduleConfig, ... }:
{ lib, ... }:

with lib;

{
  options = mkOptions {
    enable =   mkEnableOption "Enable silent boot";
    plymouth = mkEnableOption "Use Plymouth for the boot splash screen";
  };

  config = mkIf moduleConfig.enable {
    boot.plymouth = {
      enable = moduleConfig.plymouth;
    };

    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
    boot.loader.timeout = 0;

    boot.kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      ] ++ (lib.optional moduleConfig.plymouth "plymouth.use-simpledrm=1");
  };
}