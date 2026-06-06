{inputs, ...}: {
  flake.overlays.default = final: prev:
    with inputs; {
      niri = niri-wm.packages.x86_64-linux.niri-unstable;
      lzbt = lanzaboote.packages.x86_64-linux.lzbt;
      stub = lanzaboote.packages.x86_64-linux.stub;
    };

  flake.internal.allOverlays = with inputs; [
    self.overlays.default
    millennium.overlays.default
    nix-cachyos-kernel.overlays.pinned
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = inputs.self.internal.allOverlays;
    };
  };
}
