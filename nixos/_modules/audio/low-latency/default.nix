{ mkOptions, moduleConfig, ... }:
{ lib, ... }:

with lib;

{
  options = mkOptions {
    enable = mkEnableOption "Tuning Pipewire for low latency audio";
  };

  config = mkIf moduleConfig.enable {
    services.pipewire.extraConfig.pipewire."90-low-latency"."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
      "default.clock.quantum" = 128;
      "default.clock.min-quantum" = 128;
      "default.clock.max-quantum" = 128;
    };
  };
}