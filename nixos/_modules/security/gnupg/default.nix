{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure ssh service options";
    pinentryPackage = mkOption {
      type = types.package;
      default = pkgs.pinentry-gnome3;
      description = "Which pinentry package to use. The path to the mainProgram as defined
      in the package's meta attributes will be set in /etc/gnupg/gpg-agent.conf. If not set
      by the user, it'll pick an appropriate flavor depending on the system configuration
      (qt flavor for lxqt and plasma, gtk2 for xfce, gnome3 on all other systems with X enabled,
      curses otherwise).";
    };
  };

  config = mkIf moduleConfig.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      pinentryPackage = moduleConfig.pinentryPackage;
    };
  };
}
