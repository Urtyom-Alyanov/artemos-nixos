{
  moduleConfig,
  mkOptions,
  ...
}: {
  lib,
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
}
