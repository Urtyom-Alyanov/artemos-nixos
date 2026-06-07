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
    enable = mkEnableOption "Expose python3 package in home environment";

    pm = mkOption {
      type = types.attrsOf types.bool;
      description = "Python package manager options (uv)";
      default = {uv = false;};
    };
  };

  config = mkIf moduleConfig.enable {
    home.packages = with pkgs; [python3] ++ optional moduleConfig.pm.uv uv;
  };
}
