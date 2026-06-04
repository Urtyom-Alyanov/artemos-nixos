{
  moduleConfig,
  mkOptions,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Use russian localization";
    useCUserDirs = mkEnableOption "Use english naming for xdg user dirs";
  };

  config = mkIf moduleConfig.enable {
    services.xserver.xkb = {
      layout = "us,ru";
      options = "grp:caps_toggle";
    };

    console = {
      useXkbConfig = true;
    };

    i18n.defaultLocale = "ru_RU.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };

    time.timeZone = "Europe/Moscow";

    environment.etc."xdg/user-dirs.defaults".text = mkIf moduleConfig.useCUserDirs ''
      DESKTOP=Desktop
      DOWNLOAD=Downloads
      TEMPLATES=Templates
      PUBLICSHARE=Public
      DOCUMENTS=Documents
      MUSIC=Music
      PICTURES=Pictures
      VIDEOS=Videos
    '';
  };
}
