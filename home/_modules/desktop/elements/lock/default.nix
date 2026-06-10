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
    inhibitAudio = mkEnableOption "inhibit on audio";
  };

  config = mkIf moduleConfig.enable (mkMerge [
    {
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock;
        settings = {
          color = lib.mkForce "000000";
          image = lib.mkForce false;
        };
      };

      services.swayidle = {
        enable = true;
        events = {
          before-sleep = "${pkgs.playerctl}/bin/playerctl pause; ${pkgs.swaylock}/bin/swaylock -f";
          lock = "${pkgs.swaylock}/bin/swaylock -f";
        };

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
    }
    (mkIf moduleConfig.inhibitAudio {
      systemd.user.services.sway-audio-idle-inhibit = {
        Unit = {
          Description = "Inhibit idle management when audio is playing";
          PartOf = ["graphical-session.target"];
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
          Restart = "always";
        };
      };
    })
  ]);
}
