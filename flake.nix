# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "ajb-nix";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko/latest";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    headplane = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:tale/headplane";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    import-tree.url = "github:vic/import-tree";
    niri.url = "github:sodiboo/niri-flake";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs-darwin";
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    noctalia = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:noctalia-dev/noctalia-shell";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    systems.url = "github:nix-systems/default";
  };

}
