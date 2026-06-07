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
    enable = mkEnableOption "Install system compilers (GCC and Clang)";
  };

  config = mkIf moduleConfig.enable {
    home.packages = [pkgs.gcc pkgs.clang];
  };
}
