{ inputs, ... }:
{
  flake-file.inputs = {
    # SFMono w/ patches
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  flake.modules.nixos.fonts =
    { pkgs, ... }:
    let
      fontOverlay = (
        final: prev: {
          sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
            pname = "sf-mono-liga-bin";
            version = "dev";
            src = inputs.sf-mono-liga-src;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };
        }
      );
    in
    {
      nixpkgs.overlays = [ fontOverlay ];
      fonts.packages = [ pkgs.sf-mono-liga-bin ];
    };
}
