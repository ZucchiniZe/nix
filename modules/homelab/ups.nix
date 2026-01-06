{
  flake.modules.nixos.ups = {
    power.ups = {
      enable = true;
      mode = "standalone"; # TODO: change to netserver
      openFirewall = true;
      ups.noodle-factory = {
        driver = "usbhid-ups";
        port = "auto"; # for usb since `port` refers to a serial port
        description = "the main ups for the noodle factory, connected via usb to qatsi";
      };
    };
  };
}
