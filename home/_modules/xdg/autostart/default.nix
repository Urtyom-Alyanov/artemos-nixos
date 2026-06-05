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
    enable = mkEnableOption "add xdg autostart files and generate desktop entries";
    entries = mkOption {
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          exec = mkOption {
            type = types.str;
            description = "The path to the executable file";
            example = "${pkgs.throne}/share/throne/Throne";
          };
          flags = mkOption {
            type = types.str;
            description = "Additional flags for execution";
            example = "-tray -appdata";
            default = "";
          };
        };
      });
    };
  };

  config = mkIf moduleConfig.enable {
    xdg.configFile =
      mapAttrs' (
        name: execConfig: let
          flagsStr = optionalString (execConfig.flags != "") " ${execConfig.flags}";
        in
          nameValuePair "autostart/${name}.desktop" {
            text = ''
              [Desktop Entry]
              Type=Application
              Name=${name}
              Exec=${execConfig.exec}${flagsStr}
              Terminal=false
            '';
          }
      )
      moduleConfig.entries;
  };
}
