{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "qatsi";

  flake.modules.nixos.qatsi = {
    imports = with inputs.self.modules.nixos; [
      system-default
      proxmox-vm
      alex
      ssh
    ];

    networking.hostName = "qatsi";

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.05";
  };
}
