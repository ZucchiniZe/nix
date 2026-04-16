{
  flake.modules.nixos.sonarr =
    { config, lib, ... }:
    let
      service = "sonarr";
      cfg = config.homelab.services.${service};
      fullUrl = "${service}.${config.homelab.baseDomain}";
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable sonarr";
        port = lib.mkOption {
          type = lib.types.int;
          default = 8989;
        };
        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/sonarr";
        };
      };
      config = lib.mkIf cfg.enable {
        services.${service} = {
          enable = true;
          settings.server.port = cfg.port;
          dataDir = cfg.dataDir;
        };

        services.caddy.virtualHosts.${fullUrl}.extraConfig = ''
          reverse_proxy http://localhost:${toString cfg.port}
        '';
      };
    };
}
