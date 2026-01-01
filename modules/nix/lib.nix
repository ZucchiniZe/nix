{
  inputs,
  ...
}:
{
  # setup tools for the dendritic nix pattern of feature first configuration.

  # using the flake parts module system
  # and flake-file to generate the root flake
  # and then importing all of the nix files in the module dir

  # https://github.com/hercules-ci/flake-parts
  # https://github.com/vic/flake-file
  # https://github.com/vic/import-tree

  # to generate `nix run .#write-flake`

  flake-file.inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-file.url = "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
  };

  import = [
    inputs.flake-parts.flakeModules.modules
    inputs.flake-file.flakeModules.default
  ];

  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
  '';

  flake-file.description = "ajb-nix";

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
}
