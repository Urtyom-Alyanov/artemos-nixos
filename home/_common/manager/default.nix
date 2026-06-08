{
  inputs,
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
    niri-wm.homeModules.stylix
    niri-wm.homeModules.niri
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
  };

  home.sessionPath = ["$HOME/.local/bin"];
  home.stateVersion = "26.11";
}
