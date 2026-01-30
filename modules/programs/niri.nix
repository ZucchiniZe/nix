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
      settings.spawn-at-startup = [ { command = [ "noctalia-shell" ]; } ];
    };

    programs.noctalia-shell = {
      enable = true;
      # systemd.enable = true;
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
          niri = {
            prettyName = "Niri";
            comment = "A scrollable-tiling Wayland compositor";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };
      };
    };
}
