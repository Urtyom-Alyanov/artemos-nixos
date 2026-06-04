{ lib, inputs, ... }:
let
  homeDir = ./.;
  dirContents = builtins.readDir homeDir;
  userNames = lib.attrsets.filterAttrs (
    name: type: type == "directory" && !(lib.strings.hasPrefix "_" name)
  ) dirContents;

  mkUserEntries = userName: let
    userPath = homeDir + "/${userName}";
    managerPath = userPath + "/manager";
    systemPath = userPath + "/system";
  in {
    name = userName;
    value = {
      hasManager = builtins.pathExists managerPath;
      hasSystem = builtins.pathExists systemPath;

      managerModule = managerPath;
      systemModule = systemPath;
    };
  };

  usersData = lib.attrsets.mapAttrs' (name: _: mkUserEntries name) userNames;

  mkStandaloneHome = userName: data: inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./_common/manager
      ./_modules
      data.managerModule
    ];
  };

  mkNixOSHomeModule = userName: data: {
    imports = lib.optional data.hasSystem data.systemModule;

    home-manager.users."${userName}" = lib.mkIf data.hasManager {
      imports = [ data.managerModule ];
    };
  };

  nixosHomeShared = {
    home-manager.sharedModules = [ ./_common/manager ./_modules ];
    imports = lib.optional (builtins.pathExists ./_common/system) ./_common/system;
  };

  nixosHomeModules = lib.mapAttrsToList (name: data: mkNixOSHomeModule name data) usersData;

  managerUsers = lib.attrsets.filterAttrs (_: data: data.hasManager) usersData;
in
{
  _module.args = {
    inherit nixosHomeModules nixosHomeShared;
  };

  flake.homeConfigurations = lib.attrsets.mapAttrs (name: data: mkStandaloneHome name data) managerUsers;
}