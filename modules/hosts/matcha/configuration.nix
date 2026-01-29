{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "matcha";

  flake.modules.nixos.matcha = {
    imports = with inputs.self.modules.nixos; [
      limine-boot
      # system-desktop
      system-default
      alex
    ];

    home-manager.users."alex".imports = [ inputs.self.modules.homeManager.system-desktop ];

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

    networking.hostName = "matcha";
    networking.networkmanager.enable = true;

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.11";
  };
}
