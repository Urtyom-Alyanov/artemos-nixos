{
  inputs,
  pkgs,
  self,
  ...
}: let
  secretsDir = "${self}/secrets/agenix";
  hashedDir = "${self}/secrets/hashed";
in {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  _module.args = {
    inherit secretsDir hashedDir;
  };

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

  home.stateVersion = "26.11";
}
