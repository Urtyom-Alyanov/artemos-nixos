{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Activate experimental features";
  };

  config = mkIf moduleConfig.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
