{
  flake.modules.nixos.jellyfin =
    { config, lib, ... }:
    let
      service = "jellyfin";
      cfg = config.homelab.services.${service};
      fullUrl = "${service}.${config.homelab.baseDomain}";
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable jellyfin";
      };
      config = lib.mkIf cfg.enable {
        services.jellyfin = {
          enable = true;
          # transcoding.enableHardwareEncoding = true;
          # hardwareAcceleration = {
          #   enable = true;
          #   type = "qsv";
          # };
        };

        services.caddy.virtualHosts.${fullUrl}.extraConfig = ''
          	reverse_proxy http://localhost:8096
        '';
      };
    };
}
