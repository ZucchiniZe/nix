{
  inputs,
  ...
}:
{

  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  flake.modules.nixos.system-base = {
    # use systemd boot by default for nixos implementations.
    # might want to separate into a separate systemd-boot / grub
    # feature down the line if it becomes an issue

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    nixpkgs.overlays = [
      (final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final) config system;
        };
      })
    ];

    nix.settings = {
      substituters = [
        # high priority since it's almost always used
        "https://cache.nixos.org?priority=10"
        "https://install.determinate.systems"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        # "allow-import-from-derivation"
      ];

      download-buffer-size = 1024 * 1024 * 1024;

      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    nix.extraOptions = ''
      warn-dirty = false
      keep-outputs = true
    '';

    networking = {
      useDHCP = true;
      # basic firewall hardening
      firewall = {
        logRefusedConnections = false;
        rejectPackets = true;
        allowedTCPPorts = [ 22 ];
        allowedUDPPorts = [ 53 ];
      };
    };

    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";

  };
}
