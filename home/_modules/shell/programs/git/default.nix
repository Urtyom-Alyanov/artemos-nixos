{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure git";
    username = mkOption {
      type = types.str;
      description = "Username in git system";
    };
    email = mkOption {
      type = types.str;
      description = "Username in git system";
    };
  };

  config = mkIf moduleConfig.enable {
    programs.git = {
      enable = true;

      ignores = [
        "output"
        "dist"
        "result"
        "*.sqlite3"
      ];

      lfs.enable = true;

      settings = {
        user.name = moduleConfig.username;
        user.email = moduleConfig.email;
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}
