{ inputs, ... }:
let
  username = "alex";
  flake.modules.homeManager.${username} = { };
  flake.modules.nixos.${username} = { };
  flake.modules.darwin.${username} = { };
in
{
  inherit flake;
}
