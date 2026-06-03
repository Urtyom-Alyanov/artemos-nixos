{ config, lib, ... } @ args:

let
  baseDir = toString ./.;

  mkNixOSMOdules = dir:
    let
      contents = builtins.readDir dir;
      
      files = lib.mapAttrsToList (name: type:
        let 
          path = "${toString dir}/${name}";
          CameFromModule = (type == "regular" && name == "default.nix" && dir != ./.);
        in
        if type == "directory" then
          mkNixOSMOdules path
        else if CameFromModule then
          let
            relativeDir = lib.strings.removePrefix "${baseDir}/" (toString dir);
            subPath = lib.strings.splitString "/" relativeDir;

            modulePath = [ "modules" ] ++ subPath;
            createOptions = options:
              lib.setAttrByPath modulePath options;
            moduleConfig = lib.attrsets.attrByPath modulePath {} config;
          in
          [ (import path (args // {
              inherit config lib createOptions moduleConfig modulePath;
            }))
          ]
        else
          [ ]
      ) contents;
    in
      lib.flatten files;

in
{
  imports = mkNixOSMOdules ./.;
}