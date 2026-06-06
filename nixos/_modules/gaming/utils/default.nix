{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enableGamescope = mkEnableOption "add gamescope";
    enableGamemode = mkEnableOption "add gamemode";
  };

  config = mkMerge [
    (mkIf moduleConfig.enableGamescope {
      programs.gamescope = {
        enable = true;
        enableWsi = true;
        capSysNice = true;
      };
    })

    (mkIf moduleConfig.enableGamemode {
      programs.gamemode = {
        enable = true;
        enableRenice = true;
      };
    })
  ];
}
