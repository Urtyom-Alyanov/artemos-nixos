{
  mkOptions,
  moduleConfig,
  ...
}: {
  pkgs,
  lib,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Configure nix-ld";
  };

  config = mkIf moduleConfig.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        stdenv.cc.cc.lib
        openssl
        libx11
        libxcursor
        libxrandr
        libxi
        libglvnd
        glib
        nss
        nspr
        atk
        at-spi2-atk
        cups
        libdrm
        dbus
        expat
      ];
    };
  };
}
