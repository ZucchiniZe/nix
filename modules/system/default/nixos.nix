{
  # inputs,
  ...
}:
{

  flake.modules.nixos.system-default = {

    # basic firewall hardening    
    networking.firewall = {
      logRefusedConnections = false;
      rejectPackets = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPOrts = [ 53 ];
    };

    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";

  };
}
