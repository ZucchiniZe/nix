{
  flake.modules.nixos.ups =
    {
      config,
      lib,
      ...
    }:
    let
      service = "ups";
      upsName = "noodle-ups";
      cfg = config.homelab.services.${service};
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable ups";
      };
      config = lib.mkIf cfg.enable {
        # https://www.reddit.com/r/NixOS/comments/16qcadl/ups_with_nut_usbhid_driver_and_prometheus_working/
        sops.secrets."upsmon/password".owner = "nutmon";

        power.ups = {
          enable = true;
          mode = "netserver";
          ups.${upsName} = {
            driver = "usbhid-ups";
            port = "auto"; # for usb since `port` refers to a serial port
            description = "the main ups for the noodle factory, connected via usb to qatsi - a CP1500PFCLCD";
          };

          users.upsmon = {
            passwordFile = config.sops.secrets."upsmon/password".path;
            upsmon = "primary";
          };

          upsmon.monitor.${upsName}.user = "upsmon";
        };

        services.prometheus.exporters.nut = {
          enable = true;
          port = 9199;
          listenAddress = "127.0.0.1";
          nutServer = "127.0.0.1";
        };
      };
    };
}
