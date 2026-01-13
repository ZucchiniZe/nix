{ inputs, ... }:
{
  flake-file.inputs = {
    headplane.url = "github:tale/headplane";
    headplane.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.headscale =
    { config, lib, ... }:
    let
      service = "headscale";
      cfg = config.homelab.services.${service};
    in
    {
      imports = [ inputs.headplane.nixosModules.headplane ];

      options.homelab.services.${service} = {
        enable = lib.mkEnableOption "enable headscale";
      };

      config = lib.mkIf cfg.enable {
        services.headscale.enable = true;
        services.headplane.enable = true;
      };
    };
}
