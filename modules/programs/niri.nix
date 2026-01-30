{ inputs, ... }:
{
  flake-file.inputs = {
    niri.url = "github:sodiboo/niri-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.niri = {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.niri = {
      settings = null;
      config = null;
    };

    programs.noctalia-shell = {
      enable = true;
      # settings = { };
    };
  };

  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      programs.niri.enable = true;

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      programs.uwsm = {
        enable = true;
        package = pkgs.unstable.uwsm;
        waylandCompositors = {
          hyprland = {
            prettyName = "Niri";
            comment = "A scrollable-tiling Wayland compositor";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };
      };
    };
}
