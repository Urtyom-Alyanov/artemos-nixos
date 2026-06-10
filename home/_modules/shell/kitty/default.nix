{
  moduleConfig,
  mkOptions,
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "kitty TTY emulator configure";
  };

  config = mkIf moduleConfig {
    programs.kitty = {
      enable = true;
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
        dynamic_background_opacity = true;
        repaint_delay = 2;
        input_delay = 1;
        sync_to_monitor = true;
        cursor_shape = "block";
        cursor_beam_thickness = 1.5;
        cursor_blink_interval = -1;
        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.4";
      };
    };
  };
}
