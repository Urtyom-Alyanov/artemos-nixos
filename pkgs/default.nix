{inputs, ...}: {
  flake.overlays.default = final: prev:
    with inputs; let
      system = final.system;
    in {
      niri = niri-wm.packages.${system}.niri-unstable;
      lzbt = lanzaboote.packages.${system}.lzbt;
      stub = lanzaboote.packages.${system}.stub;
    };

  flake.internal.allOverlays = with inputs; [
    self.overlays.default
    millennium.overlays.default
    nix-cachyos-kernel.overlays.pinned
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = inputs.self.internal.allOverlays;
    };
  };
}
