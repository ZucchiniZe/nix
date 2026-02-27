# implement a grandma3 on linux module
# https://gist.github.com/Swiftb0y/61ef1c8381873c66089437eed277a182
# need to create a patched version of wine
# looks pretty easy to do - wine has a patches attr that I can overrideAttrs on to supply my own
# somehow extract the windows executable
# should be easy since it looks like its a self zipped thing
# install with wine
# use this as a template https://github.com/NixOS/nixpkgs/pull/7597

{
  pkgs ? import <nixpkgs> { },
}:
let
  winePatched = pkgs.wineWow64Packages.staging.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [ ./wine-disable-winverifytrust.patch ];
  });
in
pkgs.stdenv.mkDerivation {
  name = "grandMA3";

  buildInputs = [ winePatched ];
}
