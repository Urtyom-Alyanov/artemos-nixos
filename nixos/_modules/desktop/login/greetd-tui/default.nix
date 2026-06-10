{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  silent = config.modules.boot.silent;
in {
  options = mkOptions {
    enable = mkEnableOption "activate greetd service with tuigreet";
  };

  config = mkIf moduleConfig.enable {
    services.greetd = {
      enable = true;
      greeterManagesPlymouth = silent.plymouth;
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
