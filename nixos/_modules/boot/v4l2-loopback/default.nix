{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "add v4l2loopback as kernel module";
  };

  config = mkIf moduleConfig.enable {
    boot.kernelModules = ["v4l2loopback"];
    boot.extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="Virtual Camera" exclusive_caps=1
    '';
  };
}
