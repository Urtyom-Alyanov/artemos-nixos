{
  description = "Flake with Artemos NixOS configurations";

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

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.nixfmt-rfc-style
            pkgs.nixd
          ];

          shellHook = ''
            echo "Welcome to the Artemos NixOS configuration flake development shell!"
          '';
        };
      };
    };
}
