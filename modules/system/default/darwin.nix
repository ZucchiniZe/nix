{
  inputs,
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

  flake-file.inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  flake.moduels.darwin.system-default = {

    nixpkgs.config.allowUnfree = true;
    system.stateVersion = 6;

    # use determinate nix
    nix.enable = false;
    determinate-nix.customSettings = {
      eval-cores = 0; # enabels parallel eval

    };

    # macOS convenience settings
    security.pam.services.sudo_local.touchIdAuth = true;
    system.defaults = {
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      finder = {
        ShowStatusBar = true;
        ShowPathbar = true;
        NewWindowTarget = "Home";
        AppleShowAllExtensions = true;
      };
      dock = {
        # hot corners
        wvous-tr-corner = 2; # top right mission control
        wvous-br-corner = 5; # bottom right start screensaver
        wvous-bl-corner = 10; # bottom left sleep display

        autohide = true;
        orientation = "left";
      };
    };

  };

}
