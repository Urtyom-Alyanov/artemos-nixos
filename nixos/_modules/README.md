# Artemos NixOS модули

Каждый модуль здесь - есть функция, при вызове которой возвращается тоже функция,
но которая, по сути, является классическим модулем. То есть сигнатура выглядит так:

```nix
{ mkOptions, moduleConfig, ... }: # Аргументы фабрики
{ pkgs, lib, ... }: # Стандартные аргументы NixOS модуля

with lib;

{
  options = mkOptions { ... };

  config = mkIf moduleConfig.enable { ... };
}
```

Аргументы фабрики, они же `helpers`, содержат такие значения:
```nix
{
  modulePath = [ "modules" ] ++ mPath;
  mkOptions: options =
    lib.setAttrByPath ([ "modules" ] ++ mPath) options;
  moduleConfig = lib.attrByPath helpers.modulePath {} config;
}
# Где mPath - путь до `default.nix` файла относительно `/nixos/_modules`, то есть
# если путь `/nixos/_modules/video/nvidia/default.nix` - то внутри mPath будет ["video" "nvidia"],
# следовательно внутри modulePath будет ["modules" "video" "nvidia"] и поэтому внутри
# moduleConfig будет уже находится modules.video.nvidia, а mkOptions уже создаст внутри options такой же путь
# с нужными аргументами.
```