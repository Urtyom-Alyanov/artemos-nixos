{inputs, ...}: {
  flake.overlays.default = final: prev: {};

  flake.internal.allOverlays = [
    inputs.self.overlays.default
    inputs.millennium.overlays.default
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = inputs.self.internal.allOverlays;
    };
  };
}
