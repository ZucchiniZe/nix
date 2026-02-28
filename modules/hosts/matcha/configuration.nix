{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "matcha";

  flake.modules.nixos.matcha =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        limine-boot
        system-desktop
        niri
        plasma
        alex
      ];

      home-manager.users."alex" = {
        imports = with inputs.self.modules.homeManager; [
          system-desktop
          niri
        ];

        programs.niri.settings = {
          outputs."DP-4" = {
            mode = {
              height = 1440;
              width = 3440;
              refresh = 239.984;
            };
            variable-refresh-rate = "on-demand";
            focus-at-startup = true;
            position = {
              x = 1080;
              y = 0;
            };
          };

          outputs."HDMI-A-2" = {
            transform.rotation = 90;
            position = {
              x = 0;
              y = 0;
            };
          };

          input = {
            touchpad = {
              natural-scroll = false;
              drag = true;
              scroll-factor = 0.8;
            };
            mouse = {
              accel-speed = -0.3;
            };
          };
        };
      };

      networking.hostName = "matcha";

      # add a patched wine for grandMA3 to work. only works up to 2.3.1.1, 2.3.2.0 is broken
      nixpkgs.overlays = [
        (final: prev: {
          wineWow64Packages.staging_11 = prev.wineWow64Packages.staging_11.overrideAttrs (oldAttrs: {
            patches = oldAttrs.patches ++ [ ./../../../packages/wine-disable-winverifytrust.patch ];
          });
        })
      ];
      environment.systemPackages = [ pkgs.wineWow64Packages.staging_11 pkgs.unstable.winetricks ];

      # wireless protocols
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;

      # dont delete - required for backwards compat checks
      system.stateVersion = "25.11";
    };
}
