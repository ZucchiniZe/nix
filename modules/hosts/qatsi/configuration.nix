{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "qatsi";

  flake.modules.nixos.qatsi = {
    imports = with inputs.self.modules.nixos; [
      system-default
      proxmox-vm
      alex
      caddy
    ];

    homelab.services.caddy.enable = true;

    boot.supportedFilesystems = [ "nfs" ];
    fileSystems."/mnt/playtime" = {
      device = "10.1.1.15:/volume1/20-media";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
      ];
    };

    networking.hostName = "qatsi";

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.05";
  };
}
