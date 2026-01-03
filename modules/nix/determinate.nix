{ inputs, ... }:
{
  flake-file.inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  flake.modules.darwin.determinate = {
    imports = [ inputs.determinate.darwinModules.default ];
    nix.enable = false; # determinate nix handles nix config - can configure
  };
}
