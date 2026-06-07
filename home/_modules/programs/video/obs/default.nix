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
    enable = mkEnableOption "Enable OBS Studio with plugins and CUDA support";
  };

  config = mkIf moduleConfig.enable {
    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vaapi
        waveform
        obs-vkcapture
        obs-gstreamer
        obs-backgroundremoval
        droidcam-obs
        obs-multi-rtmp
      ];

      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };
    };
  };
}
