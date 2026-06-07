{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "yt-dlp-yandex-translate";
  version = "latest";

  src = fetchFromGitHub {
    owner = "gnfalex";
    repo = "YT_yt_dlp_plugin";
    rev = "master";
    hash = "sha256-mRMlrnLkZdacVVcwe9VtbP5CbtkXPFBlfPe9XJkQ8wk=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/yt-dlp-plugins/YandexTranslate
    cp -r * $out/share/yt-dlp-plugins/YandexTranslate/
  '';

  meta = {
    description = "Плагин для yt-dlp для скачивания автоматического перевода с Yandex Translate, основанный на voice-over-translation и vot-cli";
    homepage = "https://github.com/gnfalex/YT_yt_dlp_plugin";
    license = lib.licenses.mit;
  };
}
