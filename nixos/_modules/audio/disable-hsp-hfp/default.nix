{ mkOptions, moduleConfig, ... }:
{ lib, ... }:

with lib;

{
  options = mkOptions {
    enable = mkEnableOption "Disable HSP/HFP support in Pipewire";
  };

  config = mkIf moduleConfig.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "dual";
        };

        Policy = {
          AutoSwitch = false;
        };
      };
    };

    services.pipewire.wireplumber.extraConfig."disable-hsp-hfp" = {
      "wireplumber.settings".
        "bluetooth.autoswitch-to-headset-profile" = false;

      "monitor.bluez.properties"."bluez5.roles" =
        [
          "a2dp_sink"
          "a2dp_source"
        ];
    };
    
    services.pipewire.extraConfig.pipewire."90-disable-hsp-hfp"."context.modules" = [{
      name = "libpipewire-module-protocol-pulse";
      args = {
        "pulse.properties" = {
          "bluez5.msbc-support" = false;
          "bluez5.sbc-xq-support" = true;

          "bluez5.ldac.quality" = "hq-high";

          "bluez5.codecs" = [
            "ldac"
            "aptx_hd"
            "aptx"
            "aac"
            "sbc_xq"
          ];
          "bluez5.headset-roles" = [ ];
        };
      };
    }];
  };
}