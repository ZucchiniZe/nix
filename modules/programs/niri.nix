{ inputs, ... }:
{
  flake-file.inputs = {
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake-file.nixConfig = {
    extra-substituters = [
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  flake.modules.homeManager.niri =
    { lib, pkgs, ... }:
    let
      hyper = "Super+Shift+Ctrl+Alt";
      noctaliaSpawn =
        commands:
        [
          "noctalia"
          "msg"
        ]
        ++ commands;
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia.enable = true;

      # all machines that use niri will share this config, separate config should
      # be placed in the configuration.nix for that machine
      programs.niri.settings = {
        includes = [ { path = "${pkgs.niri.doc}/share/doc/niri/default-config.kdl"; } ];
        spawn-at-startup = [ { command = [ "noctalia" ]; } ];
        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite-unstable;
        };
        input = {
          focus-follows-mouse.enable = true;
          focus-follows-mouse.max-scroll-amount = "10%";
          warp-mouse-to-focus.enable = true;
        };
        layout = {
          focus-ring.enable = false;
          border = {
            enable = true;
            active.color = "#42a4b5";
          };
          always-center-single-column = true;
          tab-indicator.width = 10;
        };
        window-rules = [
          {
            clip-to-geometry = true;
            geometry-corner-radius =
              let
                r = 8.0;
              in
              {
                top-left = r;
                top-right = r;
                bottom-left = r;
                bottom-right = r;
              };
          }
          {
            matches = [ { app-id = "dev.noctalia.Noctalia.Settings"; } ];
            open-floating = true;
            default-column-width.fixed = 1080;
            default-window-height.fixed = 920;
          }
        ];
        binds = {
          "${hyper}+R".action.spawn = [ "firefox-devedition" ];
          "Mod+Shift+Comma" = {
            hotkey-overlay.title = "Noctalia: Settings";
            action.spawn = noctaliaSpawn [
              "settings-toggle"
            ];
          };
          "Mod+Shift+C" = {
            hotkey-overlay.title = "Noctalia: Control Center";
            action.spawn = noctaliaSpawn [
              "panel-toggle"
              "control-center"
            ];
          };
          # "Mod+T" = { hotkey-overlay.title = "Terminal" };
          "Mod+D" = {
            hotkey-overlay.title = "Noctalia: Launcher";
            action.spawn = noctaliaSpawn [
              "panel-toggle"
              "launcher"
            ];
          };
          "Mod+Space" = {
            hotkey-overlay.title = "Noctalia: Launcher";
            action.spawn = noctaliaSpawn [
              "panel-toggle"
              "launcher"
            ];
          };
          "Super+Alt+L" = {
            hotkey-overlay.title = "Noctalia: Lock Screen";
            action.spawn = noctaliaSpawn [
              "session"
              "lock"
            ];
          };
          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = noctaliaSpawn [
              "media"
              "toggle"
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
    };

  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [
        inputs.niri.nixosModules.niri
        inputs.nirinit.nixosModules.nirinit
        inputs.silentSDDM.nixosModules.default
      ];

      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      niri-flake.cache.enable = true;

      # for monitor brightness control (also remember to configure i2c)
      environment.systemPackages = [
        pkgs.ddcutil
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      xdg.portal.config = {
        niri = {
          "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
        };
      };

      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-unstable;

      programs.silentSDDM = {
        enable = true;
        theme = "catppuccin-frappe";
      };

      services.nirinit = {
        enable = true;
        settings = {
          skip.apps = [ "steam" ];
        };
      };
    };
}
