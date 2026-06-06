{secretsDir, ...}: {
  homeModules = {
    shell = {
      eza.enable = true;
      fish = {
        enable = true;
        useFetchAsFishGreeting = true;
      };
      starship.enable = true;

      programs = {
        fastfetch.enable = true;
        helix.enable = true;
        hyfetch.enable = true;
        git = {
          enable = true;
          email = "urtyomalyanov@gmail.com";
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
          gpgIDorEmail = "urtyomalyanov@gmail.com";
          gpgKeyFileAgeEncrypted = "${secretsDir}/artemos.gpg.age";
        };
      };
    };
  };
}
