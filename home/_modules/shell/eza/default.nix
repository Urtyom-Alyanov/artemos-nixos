{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure eza";
  };

  config = mkIf moduleConfig.enable {
    programs.eza = {
      enable = true;
      git = true;
      colors = "always";
      icons = "always";
    };
  };
}
