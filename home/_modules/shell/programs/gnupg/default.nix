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
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure gnupg";
    gpgKeyFileAgeEncrypted = mkOption {
      type = types.path;
      description = "Age encrypted file GnuPG private key";
    };
    gpgIDorEmail = mkOption {
      type = types.str;
      description = "GnuPG key ID or e-mail";
    };
    pinentryPkg = mkOption {
      type = types.package;
      description = "Package with pinentry";
      default = pkgs.pinentry-gnome3;
    };
  };

  config = mkIf moduleConfig.enable {
    age.secrets.gpg-key = {
      file = moduleConfig.gpgKeyFileAgeEncrypted;
      mode = "0600";
    };

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = moduleConfig.pinentryPkg;
    };

    home.activation.importGpgKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
      GPG_KEY_PATH="${config.age.secrets.gpg-private-key.path}"

      if [ -f "$GPG_KEY_PATH" ]; then
        if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys "${moduleConfig.gpgIDorEmail}" >/dev/null 2>&1; then
          ${pkgs.gnupg}/bin/gpg --batch --import "$GPG_KEY_PATH"
        fi
      fi
    '';
  };
}
