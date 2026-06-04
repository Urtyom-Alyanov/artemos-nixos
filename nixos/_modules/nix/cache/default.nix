{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Activate additional cache";
  };

  config = mkIf moduleConfig.enable {
    nix.settings.builders-use-substitutes = true;
    nix.settings.substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
      "https://ezkea.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://ai.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://numtide.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
  };
}
