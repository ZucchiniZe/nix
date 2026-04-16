{
  flake.modules.nixos.prowlarr =
    { config, lib, ... }:
    let
      service = "prowlarr";
      cfg = config.homelab.services.${service};
      fullUrl = "${service}.${config.homelab.baseDomain}";
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable prowlarr";
        port = lib.mkOption {
          type = lib.types.int;
          default = 9696;
        };
        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/prowlarr";
        };
      };
      config = lib.mkIf cfg.enable {
        services.${service} = {
          enable = true;
          port = cfg.port;
          dataDir = cfg.dataDir;
        };

				services.caddy.virtualHosts.${fullUrl}.extraConfig = ''
					reverse_proxy http://localhost:${toString cfg.port}
				'';
      };
    };
}
