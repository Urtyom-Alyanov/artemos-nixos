{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure proton env vars";
    enableWayland = mkEnableOption "proton use wayland";
  };

  config = mkIf moduleConfig.enable {
    environment.variables =
      {
        DXVK_HDR = "1";
        PROTON_USE_NTSYNC = "1";
        ENABLE_GAMESCOPE_WSI = "1";
      }
      // (optionalAttrs moduleConfig.enableWayland {
        PROTON_ENABLE_WAYLAND = "1";
      });
  };
}
