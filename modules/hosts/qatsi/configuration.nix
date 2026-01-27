{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "qatsi";

  flake.modules.nixos.qatsi = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
      system-default
      proxmox-vm
      alex
      homelab
      monitor-node
    ];

    homelab.baseDomain = "bierwagen.io";
    homelab.services.caddy.enable = true;
    homelab.services.ups.enable = true;
    homelab.services.monitoring.enable = true;
    homelab.services.jellyfin.enable = true;
    # not working yet
    # homelab.services.headscale.enable = true;

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
