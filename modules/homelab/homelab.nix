{ inputs, ... }:
{
  flake.modules.nixos.homelab =
    { config, lib, ... }:
    let
      cfg = config.homelab;
    in
    {
      imports = with inputs.self.modules.nixos; [
        caddy
        headscale
        monitoring
        ups
      ];

      options.homelab = {
        enable = lib.mkEnableOption "Homelab services";
        baseDomain = lib.mkOption { type = lib.types.str; };
        adminUser = lib.mkOption {
          type = lib.types.str;
          default = "alex";
        };
      };

      config = lib.mkIf cfg.enable { };
    };
}
