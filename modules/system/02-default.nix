{ inputs, ... }:
{
  flake.modules.darwin.system-default = {
    imports = with inputs.self.darwin; [ nix-tools ];
  };

  flake.modules.nixos.system-default = {
    imports = with inputs.self.nixos; [ nix-tools ];
  };
}
