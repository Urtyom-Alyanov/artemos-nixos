{
  moduleConfig,
  mkOptions,
  ...
}: {
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "add wallpaper managment from swybg";
  };

  config = mkIf moduleConfig.enable {
    systemd.user.services.swaybg = {
      Unit = {
        Description = "Wallpaper daemon for Niri";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg --mode fill --image ${config.stylix.image}";
        Restart = "always";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
