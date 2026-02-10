{ inputs, lib, ... }:
{
  flake-file.inputs = {
    niri = {
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      # all machines that use niri will share this config, separate config should
      # be placed in the configuration.nix for that machine
      programs.niri.settings = {
        includes = [ { path = "${pkgs.niri.doc}/share/doc/niri/default-config.kdl"; } ];
      };

      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
      };
    };

  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-unstable;

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
