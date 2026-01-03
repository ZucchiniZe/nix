{ inputs, ... }:
{
  flake.modules.darwin.system-default = {
    imports = with inputs.self.modules.darwin; [ nix-tools ];
  };

  flake.modules.nixos.system-default = {
    imports = with inputs.self.modules.nixos; [ nix-tools ];
  };
}
