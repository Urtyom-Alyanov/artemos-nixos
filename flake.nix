{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./nixos
      ];

      perSystem = { config, pkgs, system, ... }: {
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
