{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "matcha";

  flake.modules.nixos.matcha = {
    imports = with inputs.self.modules.nixos; [
      limine-boot
      system-desktop
      niri
      # plasma
      alex
    ];

    home-manager.users."alex" = {
      imports = [ inputs.self.modules.homeManager.niri ];

      programs.niri.settings = {
        ouputs."DP-1" = {
          mode = "3440x1440@239.984";
          variable-refresh-rate = "on-demand";
          focus-at-startup = true;
          position = {
            x = 1080;
            y = 0;
          };
        };

        ouputs."HDMI-A-1" = {
          transform = "270";
          position = {
            x = 0;
            y = 480;
          };
        };
      };
    };

    networking.hostName = "matcha";
    networking.networkmanager.enable = true;

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.11";
  };
}
