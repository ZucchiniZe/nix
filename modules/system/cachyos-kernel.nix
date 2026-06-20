{ inputs, ... }: {
  flake-file.inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  flake-file.nixConfig = {
    extra-substituters = [
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  flake.modules.nixos.cachyos-kernel = { lib, pkgs, ... }: {
    nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

    boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
  };
}
