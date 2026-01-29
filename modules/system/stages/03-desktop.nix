{ inputs, ... }:
{
  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-default
      niri
      noctalia
    ];
  };

  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-default
      niri
    ];
  };
}
