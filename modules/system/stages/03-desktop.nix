{ inputs, ... }:
{
  flake.modules.homeManager.system-desktop = {
    # imports = with inputs.self.modules.homeManager; [
    #   # since its already imported by the alex user and i want to only sometimes use niri
    #   system-default
    #   niri
    # ];
  };

  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-default
      web-tools
      gaming
      # niri
      plasma
    ];
  };
}
