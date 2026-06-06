{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  config,
  ...
}:
with lib; let
  plymouth = config.modules.boot.plymouth;
in {
  options = mkOptions {
    enable = mkEnableOption "activate greetd service with tuigreet";
  };

  config = mkIf moduleConfig.enable {
    services.greetd = {
      enable = true;
      greeterManagesPlymouth = plymouth.enable;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet -t -c niri-session -r --remember-user-session --user-menu";
          user = "greeter";
        };
      };
    };
  };
}
