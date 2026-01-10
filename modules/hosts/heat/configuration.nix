{ inputs, ... }:
{
  flake-file.inputs = {
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "aarch64-linux" "heat";

  flake.modules.nixos.heat = {
    imports =
      with inputs.self.modules.nixos;
      [
        system-default
        alex
      ]
      ++ [ inputs.disko.nixosModules.disko ];

    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    networking = {
      hostName = "heat";
      defaultGateway = "10.0.0.1";
      interfaces.eth0 = {
        ipv4.addresses = [
          {
            # Use IP address configured in the Oracle Cloud web interface
            address = "10.0.0.3";
            prefixLength = 24;
          }
        ];
        # Only "required" for IPv6, can be false if only IPv4 is needed
        useDHCP = true;
      };
      # Note: for firewall you also need to configure open ports in the Oracle
      # Cloud web interface (Virtual Cloud Network -> Security Lists -> Ingress Rules)
    };

    # dont delete - required for backwards compat checks
    system.stateVersion = "25.05";
  };
}
