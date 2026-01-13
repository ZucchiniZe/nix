{ inputs, ... }:
let
  sharedOptions = {
    sops.defaultSopsFile = ../../secrets/default.yaml;
  };
in
{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.secrets = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  }
  // sharedOptions;
  flake.modules.darwin.secrets = {
    imports = [ inputs.sops-nix.darwinModules.sops ];
  }
  // sharedOptions;
  flake.modules.homeManager.secrets = {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];
  }
  // sharedOptions;
}
