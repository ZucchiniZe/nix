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
