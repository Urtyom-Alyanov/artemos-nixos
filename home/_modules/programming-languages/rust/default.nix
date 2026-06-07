{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  persistEnable = config.homeModules.persistence.enable or false;
in {
  options = mkOptions {
    enable = mkEnableOption "Enable Rust tooling (rustup, rust-analyzer)";
    useRustup = mkOption {
      type = types.bool;
      default = true;
      description = "Install rustup for managing Rust toolchains";
    };
  };

  config = mkIf moduleConfig.enable {
    home.packages =
      (
        if moduleConfig.useRustup
        then [pkgs.rustup]
        else []
      )
      ++ [pkgs.rust-analyzer];

    homeModules.persistence = mkIf persistEnable {
      dirs = [
        "${config.home.homeDirectory}/.cargo"
        "${config.home.homeDirectory}/.rustup"
      ];
    };
  };
}
