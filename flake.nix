{
  description = "NixOS & nix-darwin Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      deploy-rs,
      ...
    }@inputs:
    let
      gitRevision = toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown");
    in
    {
      darwinConfigurations = {
        ab-m4mbp = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs gitRevision; };
          modules = [ ./hosts/ab-m4mbp ];
        };
      };

      nixosConfigurations = {
        heat = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs gitRevision; };
          modules = [ ./hosts/heat ];
        };

        nowhere = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs gitRevision; };
          modules = [ ./hosts/nowhere ];
        };
      };

      deploy.nodes = {
        heat = {
          hostname = "heat.noodle.sh";
          remoteBuild = true;
          profiles.system = {
            sshUser = "alex";
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.heat;
          };
        };

        nowhere = {
          hostname = "nowhere.noodle.sh";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nowhere;
          };
        };
      };
    };
}
