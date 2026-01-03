{ inputs, ... }:
{
  flake.modules.homeManager.system-default = {
    imports = with inputs.self.modules.homeManager; [
      nix-tools
      cli-tools
    ];
  };

  flake.modules.darwin.system-default = {
    imports = with inputs.self.modules.darwin; [
      nix-tools
      ssh
      cli-tools
      homebrew
    ];
  };

  flake.modules.nixos.system-default = {
    imports = with inputs.self.modules.nixos; [
      nix-tools
      ssh
      cli-tools
    ];
  };
}
