{
  description = "Flake with Artemos NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./nixos
      ];

      perSystem = {pkgs, ...}: let
        formatterPkg = pkgs.alejandra;
        languageServerPkg = pkgs.nixd;
      in {
        formatter = formatterPkg;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            formatterPkg
            languageServerPkg
          ];

          shellHook = ''
            echo "Welcome to the Artemos NixOS configuration flake development shell!"
          '';
        };
      };
    };
}
