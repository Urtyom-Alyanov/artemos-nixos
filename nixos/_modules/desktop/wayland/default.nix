{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "add environvent variables for wayland workin";
  };

  config = mkIf moduleConfig.enable {
    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      KWIN_DRM_ALLOW_ANY_CONNECTOR = "1";
    };
  };
}
