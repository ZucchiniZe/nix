{
  flake.modules.nixos.caddy =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      service = "caddy";
      cfg = config.homelab.services.${service};
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable caddy";
      };
      config = lib.mkIf cfg.enable {
        sops.secrets."caddy/env".owner = "caddy";
        systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.sops.secrets."caddy/env".path ];

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        services.caddy = {
          enable = true;
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/cloudflare@v0.2.3" ];
            hash = "sha256-bL1cpMvDogD/pdVxGA8CAMEXazWpFDBiGBxG83SmXLA=";
          };

          globalConfig = ''
            email {$EMAIL}
            acme_dns cloudflare {$CF_APIKEY}
            metrics {
            	per_host
            }
          '';

          virtualHosts = {
            "hello.${config.homelab.baseDomain}".extraConfig = ''
              respond	"hello!"
            '';
          };
        };
      };
    };
}
