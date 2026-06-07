{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Enable Lutris and related gaming packages";
  };

  config = mkIf moduleConfig.enable {
    programs.lutris = {
      enable = true;

      winePackages = with pkgs; [
        wineWow64Packages.stable
        wineWow64Packages.staging
        wine
        wine-staging
      ];

      protonPackages = with pkgs; [
        proton-ge-bin
      ];

      extraPackages = with pkgs; [
        winetricks
        gamescope
        mangohud
        vulkan-loader
        vulkan-tools
        libglvnd
        gamemode
        cabextract
        zenity
        gnutls
        glib-networking
        openal
      ];

      runners = {
        wine = {
          settings = {
            system = {
              gamemode = true;
            };
          };
        };
      };
    };
  };
}
