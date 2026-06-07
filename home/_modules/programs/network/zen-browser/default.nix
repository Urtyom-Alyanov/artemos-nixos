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
  voice-over-translation-addon = let
    version = "1.11.5";
    sha256 = "027sh74f3vm97ly5jlixzazprgbg9fv0zlcbyrq9s25yrdpm011g";
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
    };

  vk-next-addon = let
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
    };
in {
  options = mkOptions {
    enable = mkEnableOption "Enable zen-browser (Firefox-based) with curated settings and addons";
    stylix = mkOption {
      type = types.attrsOf types.any;
      description = "Stylix target configuration for zen-browser (overrides stylix.targets.zen-browser)";
      example = {
        enable = true;
        profileNames = ["artemos"];
      };
    };
  };

  config = mkIf moduleConfig.enable {
    stylix.targets.zen-browser = {
      enable = moduleConfig.stylix.enable or true;
      profileNames = moduleConfig.stylix.profileNames or ["artemos"];
    };

    programs.zen-browser = {
      enable = true;

      profiles.artemos = {
        id = 0;
        isDefault = true;

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "layers.acceleration.force-enabled" = true;
          "svg.context-properties.content.enabled" = true;

          "browser.search.region" = "EE";
          "general.useragent.locale" = "ru-RU";
          "browser.shell.checkDefaultBrowser" = false;
          "signon.rememberSignons" = false;

          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "expand-on-hover";

          "widget.wayland.opaque-region.enabled" = true;
          "gfx.wayland.hdr" = true;

          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "media.rdd-vavda.enabled" = true;

          "gfx.x11-egl.force-enabled" = true;
          "gfx.webrender.all" = true;
          "media.navigator.mediadatadecoder_vpx_enabled" = true;
          "media.gpu-process.enabled" = true;

          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;

          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.tabs.unloadOnLowMemory" = true;

          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 15;
          "xpinstall.signatures.required" = false;
        };

        policies = {
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            };

            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            };

            "sponsorBlocker@ajay.app" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            };

            "vot-extension@firefox" = {
              installation_mode = "force_installed";
              install_url = "file://${voice-over-translation-addon}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/vot-extension@firefox.xpi";
              default_area = "navbar";
            };

            "addon@vknext.net" = {
              installation_mode = "force_installed";
              install_url = "file://${vk-next-addon}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/addon@vknext.net.xpi";
              default_area = "navbar";
            };

            "{762f9885-c3df-498c-9464-ed9c14d26134}" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislike/latest.xpi";
              default_area = "navbar";
            };
          };

          ExtensionUpdate = true;
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin-upstream
          voice-over-translation-addon
          sponsorblock
          return-youtube-dislikes
          vk-next-addon
        ];

        search = {
          default = "google";
          force = true;

          engines = {
            nix-pkgs = {
              name = "Nix Packages";
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nixpkgs"];

              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                  ];
                }
              ];
            };

            nix-modules = {
              name = "Nix Options";
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nixopts"];

              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                  ];
                }
              ];
            };

            hm-modules = {
              name = "Home Manager Options";
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hmopts"];

              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "source";
                      value = "home_manager";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };
}
