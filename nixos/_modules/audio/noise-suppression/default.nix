{ mkOptions, moduleConfig, ... }:
{ lib, ... }:
{}:

with lib;

{
  options = mkOptions {
    enable = mkEnableOption "Enable noise suppression module";

    threshold = mkOption {
      type = types.float;
      default = 75.0;
      description = "The VAD threshold for the RNNoise plugin, in percentage.";
    };

    gracePeriod = mkOption {
      type = types.int;
      default = 330;
      description = "The VAD grace period for the RNNoise plugin, in milliseconds.";
    };
    
    retroactiveGrace = mkOption {
      type = types.int;
      default = 0;
      description = "The retroactive VAD grace period for the RNNoise plugin, in milliseconds.";
    };
  };

  config = mkIf moduleConfig.enable {
    security.rtkit.enable = true;

    environment.systemPackages = [ pkgs.rnnoise-plugin ];
    
    services.pipewire = {
      extraLadspaPackages = [ pkgs.rnnoise-plugin ];

      extraConfig.pipewire."95-rnnoise"."context.modules" = [{
        name = "libpipewire-module-filter-chain";
        args = {
          "module.lazy" = true;
          "node.description" = "Noise Cancelling Microphone (RNNoise LADSPA)";
          "media.name" = "Source without noise";

          "filter.graph".nodes = [{
            type = "ladspa";
            name = "rnnoise";
            plugin = "librnnoise_ladspa";
            label = "noise_suppressor_mono";
            control = {
              "VAD Threshold (%)" = moduleConfig.threshold;
              "VAD Grace Period (ms)" = moduleConfig.gracePeriod;
              "Retroactive VAD Grace (ms)" = moduleConfig.retroactiveGrace;
            };
          }];

          "capture.props" = {
            "node.name" = "capture.rnnoise_source";
            "node.passive" = true;
            "audio.rate" = 48000;
            "audio.channels" = 1;
            "audio.position" = [ "MONO" ];
          };
          "playback.props" = {
            "node.name" = "rnnoise_source";
            "media.class" = "Audio/Source";
            "node.latency" = "1024/48000";
            "audio.rate" = 48000;
            "audio.channels" = 1;
            "audio.position" = [ "MONO" ];
            "priority.driver" = 2500;
            "priority.session" = 2500;
          };
        };
      }];
    };
  };
}