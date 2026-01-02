{
  # inputs,
  ...
}:
{

  flake.modules.nixos.system-base = {
    # use systemd boot by default for nixos implementations.
    # might want to separate into a separate systemd-boot / grub
    # feature down the line if it becomes an issue

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

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
