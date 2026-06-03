{ config, lib, ... } @ args:

let
  baseDir = toString ./.;

  mkNixOSModules = dir:
    let
      contents = builtins.readDir dir;
      
      files = lib.mapAttrsToList (name: type:
        let 
          path = "${toString dir}/${name}";
          CameFromModule = (type == "regular" && name == "default.nix" && dir != ./.);
        in
        if type == "directory" then
          mkNixOSModules path
        else if CameFromModule then
          [ path ]
        else
          [ ]
      ) contents;
    in
      lib.flatten files;

  modulePaths = mkNixOSModules ./.;

  makeArgsForModule = path: { config, ... }:
    let
      dir = builtins.dirOf path;
      relativeDir = lib.strings.removePrefix "${baseDir}/" (toString dir);
      subPath = lib.strings.splitString "/" relativeDir;
      modulePath = [ "modules" ] ++ subPath;
    in {
      key = toString path; 
      _module.args = {
        inherit modulePath;
        moduleConfig = lib.attrsets.attrByPath modulePath {} config;
        createOptions = options: lib.setAttrByPath modulePath options;
      };
    };

in
{
  imports = mkNixOSModules ./. ++ (map makeArgsForModule modulePaths);
}