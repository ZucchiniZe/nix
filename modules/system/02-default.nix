{ inputs, ... }:
{
  flake.modules.darwin.system-default = {
    imports = with inputs.self.modules.darwin; [ nix-tools ];
  };

  flake.modules.nixos.system-default = {
    imports = with inputs.self.modules.nixos; [ nix-tools ];
  };

  flake.modules.homeManager.system-default = {
    imports = [ inputs.self.modules.homeManager.nix-tools ];
  };
}
