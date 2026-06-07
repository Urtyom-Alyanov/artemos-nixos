{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  config,
  ...
}:
with lib; let
  persistEnable = config.homeModules.persistence.enable or false;
in {
  options = mkOptions {
    enable = mkEnableOption "setup C local for xdg user dirs";
  };

  config = mkIf moduleConfig.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      download = "${config.home.homeDirectory}/Downloads";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      projects = "${config.home.homeDirectory}/Documents/Projects";
    };

    homeModules.persistence = mkIf persistEnable {
      dirs = [
        config.xdg.userDirs.desktop
        config.xdg.userDirs.download
        config.xdg.userDirs.templates
        config.xdg.userDirs.publicShare
        config.xdg.userDirs.documents
        config.xdg.userDirs.music
        config.xdg.userDirs.pictures
        config.xdg.userDirs.videos
        config.xdg.userDirs.projects
        # (language-specific persistence dirs moved to language modules)
      ];
    };
  };
}
