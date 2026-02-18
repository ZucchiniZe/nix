{ inputs, ... }:
{
  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-default
      theme
    ];
  };

  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-default
      web-tools
      gaming
      terminal
      fonts
    ];
  };
}
