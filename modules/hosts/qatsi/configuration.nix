{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "qatsi";

  flake.modules.nixos.qatsi = {
    imports = with inputs.self.modules.nixos; [
      system-base
    ];

    networking.hostName = "qatsi";

  };
}
