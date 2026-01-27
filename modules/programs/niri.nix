{ inputs, ... }:
{
  flake.modules.homeManager.niri = {
    imports = with inputs.self.modules.homeManager; [ ];
  };

  flake.modules.nixos.niri = {
    imports = with inputs.self.modules.nixos; [ ];
  };
}
