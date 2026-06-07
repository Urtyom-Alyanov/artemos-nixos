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
    enable = mkEnableOption "switch into cachyos drugs kernel";
  };

  config = mkIf moduleConfig.enable {
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;
  };
}
