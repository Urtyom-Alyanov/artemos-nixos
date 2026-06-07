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
    enable = mkEnableOption "Install LibreOffice (fresh)";
  };

  config = mkIf moduleConfig.enable {
    home.packages = with pkgs; [libreoffice-fresh];
  };
}
