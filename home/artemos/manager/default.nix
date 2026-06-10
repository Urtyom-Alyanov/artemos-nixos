{
  secretsDir,
  pkgs,
  ...
}: let
  email = "urtyomalyanov@gmail.com";
in {
  homeModules = {
    desktop = {
      elements = {
        rofi.enable = true;
        waybar.enable = true;
        swaybg.enable = true;
        lock.enable = true;
      };
      window-managers.niri.enable = true;
    };
    persistence.enable = true;
    programming-languages = {
      compilers.enable = true;
      csharp.enable = true;
      java.enable = true;
      python.enable = true;
      rust.enable = true;
    };

    themization.stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      image = "${pkgs.nixos-artwork.wallpapers.catppuccin-mocha}/share/backgrounds/nixos/nixos-wallpaper-catppuccin-mocha.png";
    };
    programs = {
      gaming = {
        lutris.enable = true;
        prism-launcher.enable = true;
        steam = {
          enable = true;
          autostart = false;
        };
      };

      network = {
        discord = {
          autostart = true;
          enable = true;
        };
        qbittorrent.enable = true;
        telegram = {
          autostart = true;
          enable = true;
        };
      };

      office.libreoffice.enable = true;

      video = {
        mpv.enable = true;
        obs.enable = true;
      };
    };
    shell = {
      eza.enable = true;
      fish = {
        enable = true;
        useFetchAsFishGreeting = true;
      };
      starship.enable = true;
      kitty.enable = true;

      programs = {
        fastfetch.enable = true;
        helix.enable = true;
        hyfetch.enable = true;
        git = {
          inherit email;
          enable = true;
          username = "Urtyom-Alyanov";
        };
        ssh = {
          enable = true;
          settings = {
            "Host saloloh.cdn.artemos.space" = {
              User = "artemos";
            };
          };
          identityFileAgeEncrypted = "${secretsDir}/artemos.ssh.age";
        };
        gnupg = {
          enable = true;
          gpgIDorEmail = email;
          gpgKeyFileAgeEncrypted = "${secretsDir}/artemos.gpg.age";
        };
      };
    };
  };
}
