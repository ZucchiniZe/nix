{
  flake.modules.nixos.matcha = {
    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" "mt7921e" ];
    boot.extraModulePackages = [ ];
    # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # enable nvidia drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      # enable beta drivers
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    boot.loader.limine.extraEntries = ''
         /+Other Bootloaders
         //Windows Boot Manager
       	    protocol: efi_chainload
      	   	image_path: guid(eb7bc0d5-50cd-497c-a082-d261afa0b5da):/efi/Microsoft/Boot/bootmgfw.efi
    '';

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
