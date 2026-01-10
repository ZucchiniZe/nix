{
  flake.modules.nixos.ups = {
    # https://www.reddit.com/r/NixOS/comments/16qcadl/ups_with_nut_usbhid_driver_and_prometheus_working/
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
