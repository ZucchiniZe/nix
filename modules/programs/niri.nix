{ inputs, ... }:
{
  flake-file.inputs = {
    niri = {
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.niri =
    { lib, pkgs, ... }:
    let
      noctaliaSpawn =
        commands:
        [
          "noctalia-shell"
          "ipc"
          "call"
        ]
        ++ commands;
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      # all machines that use niri will share this config, separate config should
      # be placed in the configuration.nix for that machine
      programs.niri.settings = {
        includes = [ { path = "${pkgs.niri.doc}/share/doc/niri/default-config.kdl"; } ];
        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite-unstable;
        };
        input = {
          focus-follows-mouse.enable = true;
          warp-mouse-to-focus.enable = true;
        };
        binds = {
          "Mod+Shift+Comma" = {
            hotkey-overlay.title = "Noctalia: Settings";
            action.spawn = noctaliaSpawn [
              "settings"
              "toggle"
            ];
          };
          "Mod+Shift+C" = {
            hotkey-overlay.title = "Noctalia: Control Center";
            action.spawn = noctaliaSpawn [
              "controlCenter"
              "toggle"
            ];
          };
          # "Mod+T" = { hotkey-overlay.title = "Terminal" };
          "Mod+D" = {
            hotkey-overlay.title = "Noctalia: Launcher";
            action.spawn = noctaliaSpawn [
              "launcher"
              "toggle"
            ];
          };
          "Mod+Space" = {
            hotkey-overlay.title = "Noctalia: Launcher";
            action.spawn = noctaliaSpawn [
              "launcher"
              "toggle"
            ];
          };
          "Super+Alt+L" = {
            hotkey-overlay.title = "Noctalia: Lock Screen";
            action.spawn = noctaliaSpawn [
              "lockScreen"
              "lock"
            ];
          };
          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = noctaliaSpawn [
              "media"
              "playPause"
            ];
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn = noctaliaSpawn [
              "media"
              "next"
            ];
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn = noctaliaSpawn [
              "media"
              "previous"
            ];
          };
        };
      };

      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
      };
    };

  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [
        inputs.niri.nixosModules.niri
        inputs.nirinit.nixosModules.nirinit
      ];

      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      niri-flake.cache.enable = true;

      # for monitor brightness control (also remember to configure i2c)
      environment.systemPackages = [ pkgs.ddcutil ];

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-unstable;

      services.nirinit = {
        enable = true;
        settings = {
          skip.apps = [ "steam" ];
        };
      };
    };
}
