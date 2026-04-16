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
      };
      config = lib.mkIf cfg.enable {
        services.${service} = {
          enable = true;

        };

        services.caddy.virtualHosts.${fullUrl}.extraConfig = ''
          					reverse_proxy http://
          				'';
      };
    };
}
