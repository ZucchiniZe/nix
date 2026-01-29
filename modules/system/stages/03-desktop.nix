{ inputs, ... }:
{
  flake.module.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
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
