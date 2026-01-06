{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "qatsi";

  flake.modules.nixos.qatsi = {
    imports = with inputs.self.modules.nixos; [
      system-default
      proxmox-vm
      alex
      ups
    ];

    power.ups.ups.noodle-factory = {
      driver = "usbhid-ups";
      port = "auto"; # for usb since `port` refers to a serial port
      description = "the main ups for the noodle factory, connected via usb to qatsi";
    };

    networking.hostName = "qatsi";

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.05";
  };
}
