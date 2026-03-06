{ inputs, ... }:
{
  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "ab-m4mbp";

  flake.modules.darwin.ab-m4mbp = {
    imports = with inputs.self.modules.darwin; [
      system-desktop
      alex
    ];

    home-manager.users."alex".imports = with inputs.self.modules.homeManager; [
      system-desktop
    ];

    networking.hostName = "ab-m4mbp";

    system = {
      primaryUser = "alex";
      stateVersion = 6;
    };
  };
}
