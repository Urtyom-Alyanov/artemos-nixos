{
  pkgs,
  lib,
}: let
  version = "14.13.0";
  sha256 = "01v88l9k361gb9s78k3j842wk0mwz1xfzhlk3cx4vjcnd4p6piwf";
in
  pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon {
    pname = "vk-next-addon";
    inherit version sha256;
    addonId = "addon@vknext.net";

    urls = [
      "https://addons.mozilla.org/firefox/downloads/file/4774336/vknext-${version}.xpi"
    ];

    meta = with lib; {
      homepage = "https://vknext.net/vknext";
      description = "Лучшее расширение для ВКонтакте с множеством функций, в числе которых есть эксклюзивные.";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  }
