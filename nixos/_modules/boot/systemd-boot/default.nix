{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "use systemd-boot instead of GRUB";
  };

  config = mkIf moduleConfig.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = false;
  };
}
