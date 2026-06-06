{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "switch into cachyos drugs kernel";
  };

  config = mkIf moduleConfig.enable {
    boot.kernelPackages = pkgs.cachyosKernel.linuxPackages-cachyos-bore-lto;
  };
}
