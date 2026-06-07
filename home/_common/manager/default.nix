{
  inputs,
  pkgs,
  self,
  lib,
  isStandalone,
  ...
}: let
  secretsDir = "${self}/secrets/agenix";
  hashedDir = "${self}/secrets/hashed";
in {
  imports = with inputs; [
    agenix.homeManagerModules.default
    stylix.homeModules.stylix
    zen-browser.homeModules.beta
    nixcord.homeModules.nixcord
  ];

  _module.args = {
    inherit secretsDir hashedDir;
  };

  homeModules.persistence.enable =
    if isStandalone
    then lib.mkForce false
    else lib.mkDefault false;

  homeModules.xdg.autostart = {
    enable = true;
    entries = {
      # throne = {
      #   exec = "${pkgs.throne}/share/throne/Throne";
      #   flags = "-tray -appdata";
      # };
      steam = {
        exec = "${pkgs.steam}/bin/steam";
        flags = "-silent";
      };
      tdesktop = {
        exec = "${pkgs.ayugram-desktop}/bin/AyuGram";
        flags = "-autostart";
      };
      discord = {
        exec = "${pkgs.equibop}/bin/equibop";
        flags = "--start-minimized";
      };
    };
  };

  home.sessionPath = ["$HOME/.local/bin"];
  home.stateVersion = "26.11";
}
