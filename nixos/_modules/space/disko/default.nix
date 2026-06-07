{
  mkOptions,
  moduleConfig,
  ...
}: {
  config,
  lib,
  ...
}:
with lib; let
  genericBtrfsOptions = ["noatime" "space_cache=v2"];
  ssdBtrfsOptions = ["ssd" "discard=async"] ++ genericBtrfsOptions;
  hddBtrfsOptions = ["nossd" "autodefrag"] ++ genericBtrfsOptions;

  genericHddBtrfs = ["compress=zstd:3"] ++ hddBtrfsOptions;
  nocowHddBtrfs = ["nodatacow" "compress=none"] ++ hddBtrfsOptions;

  genericSsdBtrfs = ["compress=zstd:1"] ++ ssdBtrfsOptions;
  nocowSsdBtrfs = ["nodatacow" "compress=none"] ++ ssdBtrfsOptions;

  impermanenceEnable = config.modules.boot.impermanence.enable;

  hasWindows = moduleConfig.bootDisk.dualbootWindows.enable;
  hasRecovery = hasWindows && moduleConfig.bootDisk.dualbootWindows.recoveryCreate;
  hasSystemPersist = moduleConfig.bootDisk.systemBtrfsPartition.createPersistSubvol;
  swapSize = moduleConfig.bootDisk.systemBtrfsPartition.swapFile;
in {
  options = mkOptions {
    enable = mkEnableOption "Enable the `disko` disks managment";
    bootDisk = mkOption {
      description = "Choose the loadable disk";
      type = types.submodule {
        options = {
          device = mkOption {
            description = "A device path";
            default = "/dev/sda";
            type = types.str;
          };

          isSsd = mkEnableOption "SSD mount options";

          systemBtrfsPartition = mkOption {
            description = "Configuration BTRFS subvolumes";
            type = types.submodule {
              options = {
                createPersistSubvol = mkOption {
                  default = impermanenceEnable;
                  description = "Create a persistence subvols (@blank, @persist)";
                  type = types.bool;
                };

                swapFile = mkOption {
                  type = types.nullOr types.str;
                  description = "Create a swap subvol (@swap) with swapfile";
                  default = null;
                };

                homes = mkOption {
                  type = types.listOf types.str;
                  description = "Create a subvols for user home";
                  default = [];
                };
              };
            };
          };

          dualbootWindows = mkOption {
            description = "Partition for windows creation";
            type = types.submodule {
              options = {
                enable = mkEnableOption "Create Microsoft Windows patitions";
                size = mkOption {
                  description = "A size for windows partition";
                  default = "128G";
                  type = types.str;
                };
                recoveryCreate = mkEnableOption "Create the Windows Recovery Partition";
              };
            };
          };
        };
      };
    };

    homeDisks = mkOption {
      description = "A disks for /home/{username}";
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          device = mkOption {
            example = "/dev/sdb";
            type = types.str;
            description = "The device of user partition";
          };
          isSsd = mkEnableOption "SSD mount options";
          createPersistSubvol = mkOption {
            default = impermanenceEnable;
            description = "Create a persistence subvols (@blank, @persist)";
            type = types.bool;
          };
        };
      });
    };
  };

  config = mkIf moduleConfig.enable {
    disko.devices.disk = let
      genericMountOptions =
        if moduleConfig.bootDisk.isSsd
        then genericSsdBtrfs
        else genericHddBtrfs;
      nocowMountOptions =
        if moduleConfig.bootDisk.isSsd
        then nocowSsdBtrfs
        else nocowHddBtrfs;
    in
      {
        main = {
          device = moduleConfig.bootDisk.device;
          type = "disk";
          content = {
            type = "gpt";
            partitions =
              {
                boot = {
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = ["fmask=0022" "dmask=0022"];
                    extraArgs = ["-n" "BOOT"];
                  };
                };
              }
              // (optionalAttrs hasWindows {
                msr = {
                  name = "Microsoft reserved partition";
                  size = "16M";
                  type = "E311";
                };
                windows = {
                  size = moduleConfig.bootDisk.dualbootWindows.size;
                  type = "EBD0";
                  content = {
                    type = "filesystem";
                    format = "ntfs";
                    mountpoint = "/mnt/windows";
                  };
                };
              })
              // (optionalAttrs hasRecovery {
                win-recovery = {
                  size = "1G";
                  type = "DE94";
                  content = {
                    type = "filesystem";
                    format = "ntfs";
                    mountpoint = "/mnt/win-recovery";
                  };
                };
              })
              // {
                root = {
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = ["-f" "-L" "NixOS"];
                    subvolumes =
                      {
                        "@nix" = {
                          mountpoint = "/nix";
                          mountOptions = genericMountOptions;

                          # priority = 1;
                        };
                        "@" = {
                          mountpoint = "/";
                          mountOptions = genericMountOptions;

                          # priority = 0;
                        };
                        "@var" = {
                          mountpoint = "/var";
                          mountOptions = nocowMountOptions;

                          # priority = 1;
                        };
                      }
                      // (optionalAttrs hasSystemPersist {
                        "@blank" = {};
                        "@persist" = {
                          mountpoint = "/persist";
                          mountOptions = genericMountOptions;

                          # priority = 1;
                        };
                      })
                      // (optionalAttrs (swapSize != null) {
                        "@swap" = {
                          mountpoint = "/swap";
                          swap = {
                            swapfile.size = swapSize;
                          };

                          # priority = 1;
                        };
                      })
                      // (foldl' (acc: userName:
                        acc
                        // {
                          # "@${userName}_home" = { мешать только будет
                          #   mountpoint = "/home/${userName}";
                          #   # priority = 1000;
                          #   mountOptions = genericMountOptions;
                          #   postMountCommands = ''
                          #     mkdir -p /mnt/home/${userName}/.local
                          #     chown -R ${userName}:100 /mnt/home/${userName}
                          #   '';
                          # };
                          "@${userName}_local" = {
                            mountpoint = "/home/${userName}/.local";
                            mountOptions = genericMountOptions;

                            # priority = 1001;
                          };
                          "@${userName}_share" = {
                            mountpoint = "/home/${userName}/.local/share";
                            mountOptions = nocowMountOptions;

                            # priority = 1002;
                          };
                          "@${userName}_steam" = {
                            mountpoint = "/home/${userName}/.local/share/Steam";
                            mountOptions = nocowMountOptions;

                            # priority = 1003;
                          };
                        }) {}
                      moduleConfig.bootDisk.systemBtrfsPartition.homes);
                  };
                };
              };
          };
        };
      }
      // (mapAttrs (userName: userCfg: let
          genericMountOptions =
            if userCfg.isSsd
            then genericSsdBtrfs
            else genericHddBtrfs;
          nocowMountOptions =
            if userCfg.isSsd
            then nocowSsdBtrfs
            else nocowHddBtrfs;
        in {
          device = userCfg.device;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              home = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f" "-L" "${userName}-home"];
                  subvolumes =
                    {
                      "@" = {
                        mountpoint = "/home/${userName}";
                        mountOptions = genericMountOptions;

                        # priority = 1000;
                      };
                      "@local" = {
                        mountpoint = "/home/${userName}/.local";
                        mountOptions = genericMountOptions;

                        # priority = 1001;
                      };
                      "@share" = {
                        mountpoint = "/home/${userName}/.local/share";
                        mountOptions = nocowMountOptions;

                        # priority = 1002;
                      };
                      "@steam" = {
                        mountpoint = "/home/${userName}/.local/share/Steam";
                        mountOptions = nocowMountOptions;

                        # priority = 1003;
                      };
                    }
                    // (optionalAttrs userCfg.createPersistSubvol {
                      "@blank" = {};
                      "@persist" = {
                        mountpoint = "/persist/home/${userName}";
                        mountOptions = genericMountOptions;

                        # priority = 1000;
                      };
                    });
                };
              };
            };
          };
        })
        moduleConfig.homeDisks);

    fileSystems =
      (lib.optionalAttrs hasSystemPersist {
        "/persist".neededForBoot = true;
      })
      // (lib.pipe moduleConfig.homeDisks [
        (lib.filterAttrs (userName: userCfg: userCfg.createPersistSubvol))
        (mapAttrsToList (userName: userCfg: [
          {
            name = "/persist/home/${userName}";
            value = {
              neededForBoot = true;
              fsType = mkDefault "none"; # если что эта хуйя переопределит
            };
          }
        ]))
        lib.flatten
        lib.listToAttrs
      ]);

    systemd.tmpfiles.rules = let
      makeUserRules = userName: let
        userUid =
          if (config.users.users ? ${userName} && config.users.users.${userName} ? uid)
          then toString config.users.users.${userName}.uid
          else userName;
      in [
        "d /home/${userName} 0755 ${userUid} 100 - -"
        "d /home/${userName}/.local 0755 ${userUid} 100 - -"
        "d /home/${userName}/.local/share 0755 ${userUid} 100 - -"
        "d /home/${userName}/.local/share/Steam 0755 ${userUid} 100 - -"
      ];

      allSharedHomes = moduleConfig.bootDisk.systemBtrfsPartition.homes;
      allDedicatedHomes = attrNames moduleConfig.homeDisks;
      allUsers = unique (allSharedHomes ++ allDedicatedHomes);
    in
      lib.flatten (map makeUserRules allUsers);
  };
}
