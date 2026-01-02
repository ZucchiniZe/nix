{
  # inputs,
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
