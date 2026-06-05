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
    enable = mkEnableOption "add throne proxy program";
  };

  config = mkIf moduleConfig.enable {
    programs.throne = {
      enable = true;
      package = pkgs.throne;
      tunMode.enable = true;
    };
  };
}
