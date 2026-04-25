{
  flake.modules.nixos.qbittorrent =
    { config, lib, ... }:
    let
      service = "qbittorrent";
      cfg = config.homelab.services.${service};
      fullUrl = "${service}.${config.homelab.baseDomain}";
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable qbittorrent";
        qui = lib.mkOption {
          description = "qui webui for bitorrent";
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "enable qui webui";
              port = lib.mkOption {
                type = lib.types.int;
                default = 8888;
              };
            };
          };
        };
        port = lib.mkOption {
          type = lib.types.int;
          default = 8080;
        };
        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/qbittorrent";
        };
      };

      config = lib.mkMerge [
        (lib.optionalAttrs cfg.enable {
          services.${service} = {
            enable = true;
            webuiPort = cfg.port;
            profileDir = cfg.dataDir;
          };

          services.caddy.virtualHosts = {
            ${fullUrl}.extraConfig = ''
              reverse_proxy http://localhost:${toString cfg.port}
            '';
          };
        })

        (lib.optionalAttrs cfg.qui.enable {
          services.qui = {
            enable = true;
            settings.port = cfg.qui.port;
          };

          services.caddy.virtualHosts = {
            "qui.${config.homelab.baseDomain}".extraConfig = ''
              	reverse_proxy http://localhost:${toString cfg.qui.port}
            '';
          };
        })
      ];
    };
}
