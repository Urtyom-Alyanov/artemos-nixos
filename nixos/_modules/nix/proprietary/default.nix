{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "allow proprietary packages";
  };

  config = mkIf moduleConfig.enable {
    nixpkgs.config.allowUnfree = true;
  };
}
