{
  flake.modules.nixos.monitoring =
    { config, lib, ... }:
    let
      service = "monitoring";
      cfg = config.homelab.services.${service};
    in
    {
      options.homelab.services.${service} = { };
      config = lib.mkIf cfg.enable { };
    };
}
