{ inputs, ... }:
{
  flake-file.inputs = {
    niri.url = "github:sodiboo/niri-flake";
  };

  flake.modules.homeManager.niri = {
    programs.niri = {
      settings = null;
      config = null;
    };
  };

  flake.modules.nixos.niri = {
    imports = [ inputs.niri.nixosModules.niri ];
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.enable = true;

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

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
