{ inputs, ... }:
{
  flake.modules.darwin.system-default = {
    imports = with inputs.self.modules.darwin; [
      nix-tools
      cli-tools
    ];
  };

  flake.modules.nixos.system-default = {
    imports = with inputs.self.modules.nixos; [
      nix-tools
      cli-tools
    ];
  };

  flake.modules.homeManager.system-default = {
    imports = with inputs.self.modules.homeManager; [
      nix-tools
      cli-tools
    ];
  };
}
