{ inputs, ... }:
{
  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-default
      _1password
      theme
      terminal
    ];
  };

  flake.modules.darwin.system-desktop = {
    imports = with inputs.self.modules.darwin; [
      system-default
      desktop-tools
      _1password
    ];
  };

  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-default
      desktop-tools
      _1password
      gaming
      fonts
    ];
  };
}
