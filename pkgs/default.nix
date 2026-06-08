{inputs, ...}: let
  substitutePkgsFromFlakes = system:
    with inputs; {
      niri = niri-wm.packages.${system}.niri-unstable;
      lzbt = lanzaboote.packages.${system}.lzbt;
      stub = lanzaboote.packages.${system}.stub;
      zen-browser = zen-browser.packages.${system}.beta;
    };

  localPackageDirs =
    builtins.filter
    (name: builtins.pathExists "${toString ./.}/${name}/default.nix")
    (builtins.attrNames (builtins.readDir ./.));
  localPackagesFromPkgs = pkgs:
    builtins.listToAttrs (map (name: {
        name = name;
        value = pkgs.${name};
      })
      localPackageDirs);
  localPackagesFromPrev = prev:
    builtins.listToAttrs (map (name: {
        name = name;
        value = prev.callPackage ./${name} {};
      })
      localPackageDirs);
in {
  flake.overlays.default = final: prev: let
    system = final.system;
    localPackages = localPackagesFromPrev prev;
  in
    localPackages
    // substitutePkgsFromFlakes system;

  flake.packages = with inputs; let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = self.internal.allOverlays;
    };
    localPackages = localPackagesFromPkgs pkgs;
  in {
    x86_64-linux =
      localPackages
      // substitutePkgsFromFlakes system;
  };

  flake.internal.allOverlays = with inputs; [
    self.overlays.default
    millennium.overlays.default
    nix-cachyos-kernel.overlays.pinned
    nur.overlays.default
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = inputs.self.internal.allOverlays;
    };
  };
}
