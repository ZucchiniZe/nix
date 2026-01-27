{ inputs, ... }:
{
  flake.modules.homeManager.noctalia = {
    imports = with inputs.self.modules.homeManager; [ ];
  };

  flake.modules.nixos.noctalia = {
    imports = with inputs.self.modules.nixos; [ ];
  };
}
