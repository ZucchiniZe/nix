{
  flake.modules.nixos.monitoring =
    # https://www.reddit.com/r/NixOS/comments/16qcadl/ups_with_nut_usbhid_driver_and_prometheus_working/
    { config, lib, ... }:
    let
      service = "monitoring";
      hostAddress = "127.0.0.1"; # assume all the services are running on the same box
      cfg = config.homelab.services.${service};
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "homelab grafana + prometheus";
        grafana = lib.mkOption {
          type = lib.types.submodule {
            options = {
              port = lib.mkOption {
                type = lib.types.int;
              };
              dataDir = lib.mkOption {
                type = lib.types.str;
              };
            };
          };
          default = {
            port = 3000;
            dataDir = "/var/lib/grafana";
          };
        };
        prometheus = lib.mkOption {
          type = lib.types.submodule {
            options = {
              port = lib.mkOption {
                type = lib.types.int;
              };
              scrape_interval = lib.mkOption { type = lib.types.str; };
            };
          };
          default = {
            port = 9001;
            scrape_interval = "1m";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        services.grafana = {
          enable = true;
          dataDir = cfg.grafana.dataDir;

          settings = {
            # prevent phone home
            analytics.feedback_links_enabled = false;
            analytics.reporting_enabled = false;

            server = {
              http_addr = hostAddress;
              http_port = cfg.grafana.port;
              enable_gzip = true;
              domain = "grafana.${config.homelab.baseDomain}";
            };
          };

          provision = {
            enable = true;
            datasources.settings.datasources = [
              {
                name = "Prometheus";
                type = "prometheus";
                url = "http://${hostAddress}:${toString cfg.prometheus.port}";
                isDefault = true;
                editable = false;
              }
            ];
          };
        };

        services.prometheus = {
          enable = true;
          port = cfg.prometheus.port;

          globalConfig.scrape_interval = cfg.prometheus.scrape_interval;

          scrapeConfigs = [
            {
              job_name = "nut";
              metrics_path = "/ups_metrics";
              params = {
                ups = [ "noodle-ups" ];
              };
              static_configs = [
                {
                  targets = [ "localhost:${toString config.services.prometheus.exporters.nut.port}" ];
                  labels = {
                    ups = "noodle-ups";
                  };
                }
              ];
            }
            {
              job_name = "node_exporter";
              static_configs = [
                {
                  targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
                }
              ];
            }
            {
              job_name = "caddy";
              static_configs = [
                {
                  # caddy admin interface is on port 2019
                  targets = [ "localhost:2019" ];
                }
              ];
            }
          ];
        };

        services.caddy.virtualHosts = {
          "grafana.${config.homelab.baseDomain}".extraConfig = ''
            	reverse_proxy http://${hostAddress}:${toString cfg.grafana.port}
          '';

          "prometheus.${config.homelab.baseDomain}".extraConfig = ''
            	reverse_proxy http://${hostAddress}:${toString cfg.prometheus.port}
          '';
        };
      };
    };
}
