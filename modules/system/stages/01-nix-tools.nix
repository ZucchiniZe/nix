{ inputs, ... }:
{
  flake.modules.homeManager.nix-tools = {
    imports = [
      inputs.self.modules.homeManager.system-base
      inputs.self.modules.generic.constants
    ];
  };

  flake.modules.darwin.nix-tools =
    { config, ... }:
    {
      imports =
        with inputs.self.modules.darwin;
        [
          system-base
          home-manager
          determinate
        ]
        ++ [ inputs.self.modules.generic.constants ];

      system.configurationRevision = config.constants.gitRevision;
    };

  flake.modules.nixos.nix-tools =
    { config, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
          system-base
          home-manager
          determinate
        ]
        ++ [ inputs.self.modules.generic.constants ];

      system.configurationRevision = config.constants.gitRevision;
    };
}
