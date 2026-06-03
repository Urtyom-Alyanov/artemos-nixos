{ moduleConfig, mkOptions, ... }:
{ lib, pkgs, ... }:

with lib;

let
  deviceSubmodule = types.submodule
    { 
      device = mkOption {
        type = types.str;
        description = "The device to use for the impermanence module.";
      };

      blankSubvolume = mkOption {
        type = types.str;
        default = "@blank";
        description = "The blank subvolume to use for the impermanence module.";
      };

      subvolume = mkOption {
        type = types.str;
        default = "@";
        description = "The root subvolume to use for the impermanence module.";
      };
    };
  
  rollbackScriptTail = { device, blankSubvolume, subvolume }: ''
    mount -o ${device} /run/rollback
    btrfs subvolume delete /run/rollback/${subvolume} 2>/dev/null || true
    btrfs subvolume snapshot /run/rollback/${blankSubvolume} /run/rollback/${subvolume}
    umount /run/rollback
  '';
in
{
  options = mkOptions {
    enable = mkEnableOption "Enable the impermanence module";

    volumes = mkOption {
      description = "The volumes to use for the impermanence module.";
      type = types.listOf deviceSubmodule;
    };
  };

  config =
    with moduleConfig;
    mkIf enable { 
      boot.initrd.systemd.services.rollback = {
        description = "Rollback BTRFS subvolumes";

        unitConfig.DefaultDependencies = "no";

        after = map volumes
          (volume: "${builtins.replaceStrings ["/dev/" "-" "/"] ["dev-" "\\x2d" "-"] volume.device}.device");
        requires = map volumes
          (volume: "${builtins.replaceStrings ["/dev/" "-" "/"] ["dev-" "\\x2d" "-"] volume.device}.device");

        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];

        serviceConfig = {
          Type = "oneshot";

          ExecStart = let rollbackScript = pkgs.writeScript "rollback-script" ''
            #!${pkgs.stdenv.shell}

            mkdir -p /run/rollback

            ${lib.concatStringsSep "\n" (map (device: rollbackScriptTail device) volumes)}
          '';
            in "${rollbackScript}";
        };
      };
    };
}