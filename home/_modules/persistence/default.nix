{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "add into persistence dir";

    files = mkOption {
      type = with types; listOf (coercedTo path toString str);
    };
    dirs = mkOption {
      type = with types; listOf (coercedTo path toString str);
    };
  };

  config = mkIf moduleConfig.enable {
    home.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      allowTrash = true;

      files = moduleConfig.files;
      directories = moduleConfig.dirs;
    };
  };
}
