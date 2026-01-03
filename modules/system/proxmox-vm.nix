{
  flake.modules.nixos.proxmox-vm = {
    services.qemuGuest.enable = true;
  };
}
