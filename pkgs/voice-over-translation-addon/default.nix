{
  pkgs,
  lib,
}: let
  version = "1.11.6";
  sha256 = "1bdkdpxsm4gpczfyjjjn36rigd2m41wmrxymgp9r26qybmrlxlz0";
in
  pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon {
    pname = "voice-over-translation-addon";
    inherit version sha256;
    addonId = "vot-extension@firefox";

    urls = [
      "https://github.com/ilyhalight/voice-over-translation/releases/download/${version}/vot-extension-firefox-${version}.xpi"
    ];

    meta = with lib; {
      homepage = "https://github.com/ilyhalight/voice-over-translation";
      description = "A small extension that adds a Yandex Browser video translation to other browsers";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
