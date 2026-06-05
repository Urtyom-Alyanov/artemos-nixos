{
  mkOptions,
  moduleConfig,
  ...
}: {
  self,
  lib,
  config,
  ...
}:
with lib; let
  opensshConfig = config.services.openssh;
in {
  options = mkOptions {
    enable = mkEnableOption "activate agenix service";
    addInstallerKey = mkEnableOption "add installer key for configuration";
  };

  config = mkIf moduleConfig.enable {
    age = {
      identityPaths =
        (
          if (opensshConfig.enable or false)
          then map (e: e.path) (lib.filter (e: e.type == "rsa" || e.type == "ed25519") opensshConfig.hostKeys)
          else []
        )
        ++ (lib.optional ((builtins.pathExists "${self}/installer-key") && moduleConfig.addInstallerKey) "${self}/installer-key");
    };
  };
}
