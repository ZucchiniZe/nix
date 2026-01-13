{
  flake.modules.nixos.monitor-node = {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9000;
      enabledCollectors = [
        "systemd"
        "processes"
      ];
    };
  };
}
