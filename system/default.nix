{ lib, inputs, ... }:
let
  # Define the directory containing host configurations
  hostsDir = ./.;

  dirContents = builtins.readDir hostsDir;
  hostNames = lib.attrsets.filterAttrs 
    (name: type: type == "directory" && !(lib.strings.hasPrefix "_" name)) 
    dirContents;

  # Function to create a NixOS system configuration for a given host
  mkHost = hostName: inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux"; 
    
    specialArgs = { inherit inputs; };
    
    modules = [
      ./_common
      ./_modules
      ./${hostName}
    ];
  };
in
{
  flake.nixosConfigurations = lib.attrsets.mapAttrs (name: _: mkHost name) hostNames;
}