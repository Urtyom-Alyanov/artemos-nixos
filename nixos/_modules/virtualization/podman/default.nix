{
  mkOptions,
  moduleConfig,
  ...
}: {
  pkgs,
  lib,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "use podman for containers";
  };

  config = mkIf moduleConfig.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
      podman-tui
    ];
  };
}
