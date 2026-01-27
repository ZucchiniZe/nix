{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "matcha";

  flake.modules.nixos.matcha = {
    imports = with inputs.self.modules.nixos; [
      limine-boot
      system-desktop
      alex
    ];

    networking.hostName = "matcha";

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.11";
  };
}
