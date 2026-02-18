{ inputs, ... }:
{
  flake-file.inputs = {
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.disko = {
    imports = [ inputs.disko.nixosModules.disko ];
  };
}
