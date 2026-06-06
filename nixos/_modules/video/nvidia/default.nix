{
  moduleConfig,
  mkOptions,
  ...
}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  videoAccelereationPkgs = with pkgs;
    [
      libva-vdpau-driver
    ]
    ++ (lib.optional moduleConfig.useLibVADriver nvidia-vaapi-driver);
in {
  options = mkOptions {
    enable = mkEnableOption "Enable NVIDIA drivers";
    useLibVADriver = mkEnableOption "Use the libva NVIDIA driver for video acceleration";
    earlyProbe = mkEnableOption "Enable early probing of NVIDIA devices";
    openDrivers = mkEnableOption "Use the official open NVIDIA drivers";
  };

  config = mkIf moduleConfig.enable {
    boot.initrd.kernelModules = mkIf moduleConfig.earlyProbe [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    environment = {
      systemPackages = videoAccelereationPkgs;
      variables =
        {
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
        }
        // (optionalAttrs moduleConfig.useLibVADriver {
          LIBVA_DRIVER_NAME = "nvidia";
          NVD_BACKEND = "direct";
        });
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        open = moduleConfig.openDrivers;
        powerManagement.enable = true;
        modesetting.enable = true;

        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };

      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = videoAccelereationPkgs;
      };
    };
  };
}
