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
    enable = mkEnableOption "activate niri wayland compositor";
  };

  config = mkIf moduleConfig.enable {
    programs.niri = {
      enable = true;
      useNautilus = true;
    };

    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}
