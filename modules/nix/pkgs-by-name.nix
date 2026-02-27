{ inputs, withSystem, ... }:
{
  flake-file.inputs = {
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    packages = {
      # since this gets written into flake.nix at the root of the directory,
      # our paths are relative to that
      url = "path:./packages";
      flake = false;
    };
  };

  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];

  perSystem = {
    pkgsDirectory = inputs.packages;
  };

  flake.modules.generic.pkgs-by-name = {
    nixpkgs.overlays = [
      (final: prev: {
        local = withSystem prev.stdenv.hostPlatform.system ({ config, ... }: config.packages);
      })
    ];
  };
}
