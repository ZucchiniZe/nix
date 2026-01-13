{
  flake.modules.nixos.homelab =
    { lib, ... }:
    {
      options.homelab = {
        baseDomain = lib.mkOption { type = lib.types.str; };
      };
    };
}
