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
    enable = mkEnableOption "Install qBittorrent client";
  };

  config = mkIf moduleConfig.enable {
    home.packages = with pkgs; [qbittorrent];
  };
}
