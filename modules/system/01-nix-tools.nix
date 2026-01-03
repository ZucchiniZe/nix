{ inputs, ... }:
{
  flake.modules.darwin.nix-tools = {
    imports =
      with inputs.self.modules.darwin;
      [
        system-base
        home-manager
        determinate
      ]
      ++ [ inputs.self.modules.generic.constants ];
  };

  flake.modules.nixos.nix-tools = {
    imports =
      with inputs.self.modules.nixos;
      [
        system-base
        home-manager
      ]
      ++ [ inputs.self.modules.generic.constants ];
  };
}
