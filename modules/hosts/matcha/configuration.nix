{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "matcha";

  flake.modules.nixos.matcha = {
    imports = with inputs.self.modules.nixos; [
      limine-boot
      system-desktop
      niri
      plasma
      alex
    ];

    home-manager.users."alex" = {
      imports = [ inputs.self.modules.homeManager.niri ];

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
      };
    };

    networking.hostName = "matcha";

    # wireless protocols
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.11";
  };
}
