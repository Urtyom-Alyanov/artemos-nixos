{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure hyfetch wrapper";
    preset = mkOption {
      default = "gay-men";
      type = types.str;
      description = "Preset for hyfetch";
    };
  };

  config = mkIf moduleConfig.enable {
    programs.hyfetch = {
      enable = true;
      settings = {
        preset = moduleConfig.preset;
        mode = "rgb";
        lightness = 0.56;
        color_align.mode = "horizontal";
        backend = "fastfetch";
        auto_detect_light_dark = true;
        light_dark = "dark";
        pride_month_disable = false;
      };
    };
  };
}
