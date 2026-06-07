{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  ...
}:
with lib; let
  anime4k = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/Anime4K_Upscale_CNN_L_x2_Denoise.glsl";
  fsr = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/FSR.glsl";
in {
  options = mkOptions {
    enable = mkEnableOption "Enable MPV media player with advanced shaders and plugins";
  };

  config = mkIf moduleConfig.enable {
    home.sessionVariables = {
      YT_DLP_PLUGINS_PATH = "${pkgs.yt-dlp-yandex-translate}/share/yt-dlp-plugins";
    };

    home.packages = with pkgs; [
      yt-dlp
      python311Packages.protobuf
    ];

    programs.mpv = {
      enable = true;

      scripts = with pkgs.mpvScripts; [
        uosc
        thumbfast
        mpris
        mpv-discord
        autoload
      ];

      config = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        hwdec = "nvdec-copy";

        profile = "gpu-hq";
        scale = "ewa_lanczossharp";
        cscale = "mitchell";
        video-sync = "display-resample";
        interpolation = "yes";
        tscale = "oversample";

        osc = "no";
        osd-bar = "no";
        border = "no";

        glsl-shader = "${anime4k}";
        sharpness = "1.0";

        ytdl-raw-options = "use-extractors=YandexTranslate,extractor-args=YandexTranslate:orig_volume=0.2";
        audio-multistreams = "yes";

        alang = "rus,ru,eng,en";
      };

      bindings = {
        "WHEEL_UP" = "seek 10";
        "WHEEL_DOWN" = "seek -10";
        "right" = "seek  5";
        "left" = "seek -5";
        "space" = "cycle pause";
        "m" = "script-binding uosc/menu";
        "CTRL+1" = "no-osd change-list glsl-shaders set \"${anime4k}\"; show-text \"Anime4K (High Quality) Active\"";
        "CTRL+2" = "no-osd change-list glsl-shaders set \"${fsr}\"; show-text \"FSR (Fast) Active\"";
        "CTRL+0" = "no-osd change-list glsl-shaders clr \"\"; show-text \"Shaders Disabled\"";
      };
    };
  };
}
