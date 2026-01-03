{
  inputs,
  ...
}:
{
  flake.modules.nixos.qatsi = {
    boot.initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
      "sr_mod"
    ];
    boot.kernelModules = [ "kvm-intel" ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
