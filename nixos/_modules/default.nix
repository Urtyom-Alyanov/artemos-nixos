{
  config,
  lib,
  ...
}: let
  baseDir = toString ./.;
  baseModulePath = "modules";

  mkNixOSModules = dir: let
    contents = builtins.readDir dir;
    files =
      lib.mapAttrsToList (
        name: type: let
          path = "${toString dir}/${name}";
          CameFromModule = type == "regular" && name == "default.nix" && dir != ./.;
        in
          if type == "directory"
          then mkNixOSModules path
          else if CameFromModule
          then [path]
          else []
      )
      contents;
  in
    lib.flatten files;

  allModuleFiles = mkNixOSModules ./.;

  evaluateModule = file: let
    relPath = lib.removeSuffix "/default.nix" (lib.removePrefix "${baseDir}/" (toString file));
    mPath = lib.splitString "/" relPath;

    helpers = {
      modulePath = [baseModulePath] ++ mPath;
      mkOptions = options: lib.setAttrByPath ([baseModulePath] ++ mPath) options;
      moduleConfig = lib.attrByPath helpers.modulePath {} config;
    };
  in
    (import file) helpers;
in {
  imports = map evaluateModule allModuleFiles;
}
