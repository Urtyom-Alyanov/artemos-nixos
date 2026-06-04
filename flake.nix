{
  description = "Flake with Artemos NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      systems = ["x86_64-linux"];

      imports = [
        ./nixos
      ];

      perSystem = {pkgs, ...}: let
        formatterPkg = pkgs.alejandra;
        languageServerPkg = pkgs.nixd;
        disko = pkgs.disko;
      in {
        formatter = formatterPkg;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            formatterPkg
            languageServerPkg
            disko
          ];

          shellHook = ''
            echo "Welcome to the Artemos NixOS configuration flake development shell!"
          '';
        };
      };
    };
}
