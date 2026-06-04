{
  self,
  lib,
  inputs,
  nixosHomeModules,
  nixosHomeShared,
  ...
}: let
  hostsDir = ./.;

  dirContents = builtins.readDir hostsDir;
  hostNames =
    lib.attrsets.filterAttrs (
      name: type: type == "directory" && !(lib.strings.hasPrefix "_" name)
    )
    dirContents;

  mkHost = hostName:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {inherit inputs self;};

      modules =
        [
          {
            networking.hostName = hostName;
          }
          ./_common
          ./_modules
          ./${hostName}
          nixosHomeShared
        ]
        ++ nixosHomeModules;
    };
in {
  flake.nixosConfigurations = lib.attrsets.mapAttrs (name: _: mkHost name) hostNames;
}
