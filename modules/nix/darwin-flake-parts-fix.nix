{
  # inputs,
  lib,
  flake-parts-lib,
  ...
}:
{

  # https://github.com/Doc-Steve/dendritic-design-with-flake-parts/blob/main/modules/nix/flake-parts%20%5B%5D/darwinConfigurations-fix.nix
  # currently there's no nix-darwin module for flake-parts,
  # so we need to manually add the darwinConfigurations option.

  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      darwinConfigurations = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = { };
      };
    };
  };
}
