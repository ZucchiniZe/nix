{
  flake.modules.nixos.monitoring =
    # https://www.reddit.com/r/NixOS/comments/16qcadl/ups_with_nut_usbhid_driver_and_prometheus_working/
    { config, lib, ... }:
    let
      service = "monitoring";
      cfg = config.homelab.services.${service};
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "homelab grafana + prometheus";
      };
      config = lib.mkIf cfg.enable {
        services.grafana = {
          enable = true;

        };

        services.prometheus = {
          enable = true;
        };
      };
    };
}
