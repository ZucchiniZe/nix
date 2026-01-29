{ inputs, ... }:
{
  flake-file.inputs = {
    niri.url = "github:sodiboo/niri-flake";
  };

  flake.modules.homeManager.niri =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.niri.homeModules.niri ];
      programs.niri = {
        # package = lib.mkForce pkgs.niri-stable;
        enable = true;
        settings = null;
        config = null;
      };
    };

  flake.modules.nixos.niri = {
    imports = [ inputs.niri.nixosModules.niri ];
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    # programs.niri.enable = true;

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        niri = {
          prettyName = "Niri";
          comment = "A scrollable-tiling Wayland compositor";
          binPath = "/run/current-system/sw/bin/niri-session";
        };
      };
    };
  };
}
