{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "use kdeconnect for share device";
  };

  config = mkIf moduleConfig.enable {
    programs.kdeconnect = {
      enable = true;
    };
  };
}
