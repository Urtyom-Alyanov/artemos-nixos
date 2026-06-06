{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  # pkgs,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure fastfetch";
  };

  config = mkIf moduleConfig.enable {
    programs.fastfetch = {
      enable = true;
      # settings = builtins.fromJSON (builtins.readFile "${pkgs.fastfetch}/share/fastfetch/presets/examples/25.jsonc");
    };
  };
}
