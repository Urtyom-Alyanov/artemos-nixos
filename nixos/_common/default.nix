{
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.default
    inputs.agenix.nixosModules.default
  ];

  _module.args = {
    secretsDir = "${self}/secrets/agenix";
    hashedDir = "${self}/secrets/hashed";
  };

  modules.services.agenix = {
    enable = true;
    addInstallerKey = true;
  };

  services.openssh = {
    enable = true;
  };

  # менять только при чистой установке
  system.stateVersion = "26.11";

  modules.boot.silent = {
    enable = true;
    plymouth = true;
  };

  modules.i18n.russian = {
    enable = true;
    useCUserDirs = true;
  };

  modules.nix = {
    garbage-collection.enable = true;
    linker.enable = true;
    cache.enable = true;
    features.enable = true;
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

  modules.themization.fonts.enable = true;

  # мало памяти не бывает
  zramSwap = {
    algorithm = "zstd";
    enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
