{
  moduleConfig,
  mkOptions,
  ...
}: {
  config,
  lib,
  pkgs,
  secretsDir,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "add mihomo proxy service";
    ageEncryptedConfig = mkOption {
      type = types.path;
      default = "${secretsDir}/mihomo.yaml.age";
      description = "The age encrypted config";
    };
  };

  config = mkIf moduleConfig.enable {
    age.secrets.mihomo-config = {
      file = moduleConfig.ageEncryptedConfig;
      mode = "0400";
      owner = "root";
    };

    services.mihomo = {
      enable = true;

      configFile = config.age.secrets.mihomo-config.path;

      webui = pkgs.metacubexd;

      tunMode = true;
      processesInfo = true;
    };
  };
}
