{
  inputs,
  ...
}:
{

  flake-file.inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  flake.modules.darwin.system-base = {
    nixpkgs.overlays = [
      (final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final) config system;
        };
      })
    ];

    nixpkgs.config.allowUnfree = true;

    # use determinate nix
    determinate-nix.customSettings = {
      # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
      eval-cores = 0;

      # Disable global registry
      flake-registry = "";

      lazy-trees = true;
      warn-dirty = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      extra-experimental-features = [
        "build-time-fetch-tree" # Enables build-time flake inputs
        "parallel-eval" # Enables parallel evaluation
      ];
      substituters = [
        # high priority since it's almost always used
        "https://cache.nixos.org?priority=10"
        "https://install.determinate.systems"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
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
        wvous-tr-corner = 2; # top right mission control
        wvous-tl-corner = 3; # top left app windows
        wvous-br-corner = 5; # bottom right start screensaver
        wvous-bl-corner = 10; # bottom left sleep display

        autohide = true;
        orientation = "left";
      };
    };
  };
}
