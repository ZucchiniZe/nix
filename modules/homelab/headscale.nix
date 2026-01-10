{
  flake.modules.nixos.headscale =
    { config, lib, ... }:
    let
      service = "headscale";
      cfg = config.homelab.services.${service};
    in
    {
      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable headscale";
      };
      config = lib.mkIf cfg.enable {
        services.headscale.enable = true;
        services.headplane.enable = true;
      };
    };
}
