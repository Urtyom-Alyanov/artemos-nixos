{
  moduleConfig,
  mkOptions,
  ...
}: {
  pkgs,
  lib,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "add swaylock";
  };

  config = mkIf moduleConfig.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock;
      settings = {
        color = lib.mkForce "000000";
        image = lib.mkForce false;
      };
    };

    systemd.user.services.sway-audio-idle-inhibit = mkIf moduleConfig.inhibitAudio {
      description = "Inhibit idle management when audio is playing";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
        Restart = "always";
      };
    };

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.playerctl}/bin/playerctl pause & ${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 360;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
