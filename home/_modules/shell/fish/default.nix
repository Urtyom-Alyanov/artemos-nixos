{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure eza";
    useFetchAsFishGreeting = mkEnableOption "using `hyfetch` command as fish greeting";
  };

  config = mkIf moduleConfig.enable {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = {
          body = optionalString (moduleConfig.useFetchAsFishGreeting) "${pkgs.hyfetch}/bin/hyfetch";
        };
      };
    };
  };
}
