{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Install uv package";
  };

  config = mkIf moduleConfig.enable {
    home.packages = with pkgs; [uv];
  };
}
