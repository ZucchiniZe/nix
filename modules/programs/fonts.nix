{ inputs, ... }:
{
  flake-file.inputs = {
    # SFMono w/ patches
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  flake.module.nixos.fonts = { 
    let
      fontOverlay = (final: prev: {
        sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
          pname = "sf-mono-liga-bin";
          version = "dev";
          src = inputs.sf-mono-liga-src;
          dontConfigure = true;
          installPhase = ''
            mkdir -p $out/share/fonts/opentype
            cp -R $src/*.otf $out/share/fonts/opentype/
          '';
        };
      });
    in
    nixpkgs.overlays = [ fontOverlay ];
    fonts.fonts = [ pkgs.sf-mono-liga-bin ];
  };
}