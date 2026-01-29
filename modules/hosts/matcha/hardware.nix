{
  flake.modules.nixos.matcha = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };
      "/mnt/data" = {
        device = "/dev/disk/by-label/linux-data";
        fsType = "btrfs";
      };
      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];
  };
}
