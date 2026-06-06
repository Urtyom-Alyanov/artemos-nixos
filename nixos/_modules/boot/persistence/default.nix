{
  moduleConfig,
  mkOptions,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Enable the persistence module for impermanence";
  };

  config = mkIf moduleConfig.enable {
    environment.persistence."/persist" = {
      enable = true;

      hideMounts = true;
      allowTrash = true;

      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/etc/xray"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };
}
