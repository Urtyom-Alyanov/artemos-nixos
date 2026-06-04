{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.default
  ];

  modules.boot.silent = {
    enable = true;
    plymouth = true;
  };

  modules.audio = {
    low-latency.enable = true;
    disable-hsp-hfp.enable = true;
    noise-suppression.enable = true;
  };

  modules.printing = {
    enable = true;
    avahiService = true;
    saneService = true;

    hp = {
      enable = true;
      withProprietaryComponent = true;
    };
  };

  time.timeZone = "Europe/Moscow";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };
}
