{
  flake.modules.nixos.matcha =
    { pkgs, config, ... }:
    {
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      # use the latest unstable kernel for the ABSOLUTE BLEEDING EDGE
      boot.kernelPackages = pkgs.unstable.linuxPackages_6_18;
      boot.kernelModules = [
        "kvm-amd"
        "mt7921e"
      ];
      boot.extraModulePackages = [ ];
      # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.i2c.enable = true;

      # enable nvidia drivers
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics.enable = true;
      hardware.nvidia = {
        # enable beta drivers
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        open = true;
        modesetting.enable = true;
        nvidiaSettings = true;
      };

      boot.loader.limine.extraEntries = ''
        /+CachyOS
        //linux-cachyos
          comment: Kernel version: 6.18.9-2-cachyos
          comment: kernel-id=linux-cachyos
          protocol: linux
          module_path: boot():/e2a5ec25e0c34fb49404f19dae1088d7/linux-cachyos/initramfs-linux-cachyos#c9082f00da5f6322409fc618575f1a88a4e4fb8a68f71c53212fa78005ab1de3baa42960205cbef07f3a18022da28171b42fc8ca2cb43ae80d7638c6b8830dfb
          path: boot():/e2a5ec25e0c34fb49404f19dae1088d7/linux-cachyos/vmlinuz-linux-cachyos#995fd692a3f1b20f5c00e687484e9117fd2f2eb083eb2b3b13b6f759eaa752432aa8bac83f9cb62a87f6ce02e2c775f10f7644dd97d93a4d52d7a74a753e3a4a
          cmdline: quiet nowatchdog splash rw rootflags=subvol=/@ root=UUID=97a32c46-1add-42dc-9f26-01e03fd5352e

        //linux-cachyos-lts
          comment: Kernel version: 6.12.69-2-cachyos-lts
          comment: kernel-id=linux-cachyos-lts
          protocol: linux
          module_path: boot():/e2a5ec25e0c34fb49404f19dae1088d7/linux-cachyos-lts/initramfs-linux-cachyos-lts#9b3e3ac9af37b50a0d788c6657783853def56914dc4c1419007d163ac8f0612f83b1321b6cd5eb83c555786cb1172c33bd4597c9663dc6fbf0c07950e96c1834
          path: boot():/e2a5ec25e0c34fb49404f19dae1088d7/linux-cachyos-lts/vmlinuz-linux-cachyos-lts#e3e8698a34ebdcbb260700694a81b8ff29a3b68432e60eda1b925cf070137aad1f9632e22e6dbb0bd9a6cac3b71eacf99ac020aa8005e0a59cf8f54e8ddee62b
          cmdline: quiet nowatchdog splash rw rootflags=subvol=/@ root=UUID=97a32c46-1add-42dc-9f26-01e03fd5352e
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
