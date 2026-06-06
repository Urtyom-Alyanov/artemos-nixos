{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    users = mkOption {
      description = "Users with system binds";
      type = types.attrsOf (types.submodule {
        options = {
          games = mkEnableOption "add bind `~/Games` to `~/.local/share/Games`";
          systemConfiguration = mkEnableOption "add bind `~/Documents/nixos` to `/persist/etc/nixos`";
          persistDirectory = mkEnableOption "add bind `~/.persist` to `/persist/home/username`";
        };
      });
    };
  };

  config = let
    cfg = moduleConfig;

    createBindsForUser = username: userCfg: let
      home = "/home/${username}";
    in
      (optionalAttrs userCfg.games {
        "${home}/.local/share/Games" = {
          device = "${home}/Games";
          fsType = "none";
          options = ["bind" "nofail"];
        };
      })
      // (optionalAttrs userCfg.systemConfiguration {
        "/persist/etc/nixos" = {
          device = "${home}/Documents/nixos";
          fsType = "none";
          options = ["bind" "nofail"];
        };
      })
      // (optionalAttrs userCfg.persistDirectory {
        "/persist/home/${username}" = {
          device = "${home}/.persist";
          fsType = "none";
          options = ["bind" "nofail"];
        };
      });
    allFileSystems = foldl' (
      acc: username:
        acc // (createBindsForUser username (getAttr username cfg.users))
    ) {} (attrNames cfg.users);
  in {
    fileSystems = allFileSystems;
    systemd.tmpfiles.rules = flatten (mapAttrsToList (username: userCfg: let
        home = "/home/${username}";
      in [
        (optionalString userCfg.games "d ${home}/Games 0755 ${username} users - -")
        (optionalString userCfg.games "d ${home}/.local/share/Games 0755 ${username} users - -")
        (optionalString userCfg.systemConfiguration "d ${home}/Documents/nixos 0755 ${username} users - -")
        (optionalString userCfg.persistDirectory "d ${home}/.persist 0755 ${username} users - -")
      ])
      cfg.users);
  };
}
