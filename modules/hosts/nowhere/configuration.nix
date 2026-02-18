{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "aarch64-linux" "nowhere";

  flake.modules.nixos.nowhere = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
      system-default
      alex
      auto-upgrade
      disko
    ];

    networking.hostName = "nowhere";

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.05";
  };
}
