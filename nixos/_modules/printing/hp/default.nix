{
  moduleConfig,
  mkOptions,
  ...
}: {
  pkgs,
  lib,
  ...
}:
with lib; let
  hpPkg =
    if moduleConfig.withProprietaryComponent
    then pkgs.hplipWithPlugin
    else pkgs.hplip;
in {
  options = mkOptions {
    enable = mkEnableOption "The HP printing service";
    withProprietaryComponent = mkEnableOption "Thr HP proprietary plugin for printing";
  };

  config = mkIf moduleConfig.enable {
    services.printing.drivers = [hpPkg];
    hardware.sane.extraBackends = [hpPkg];
  };
}
