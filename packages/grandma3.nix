{
  lib,
  stdenvNoCC,
  requireFile,
  unzip,
  libxml2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grandMA3-onPC";
  version = "2.3.2.0";

  src = requireFile {
    name = "grandMA3_stick_v2.3.2.0.zip";
    url = "https://www.malighting.com/downloads/products/grandma3/";
    sha256 = "4bff734150e5fd43409930cf7e1a8d0e95ed7f6bdbec55afb55de989beec56a3";
  };

  nativeBuildInputs = [ unzip libxml2 ];

  sourceRoot = ".";

  postUnpack = ''
    cp -r ma $out
  '';

  buildPhase = ''
    ls -l

    ls -l $src
    ls -l $out
  '';

  # installPhase = ''
  # '';

  meta = {
    description = "Lighting control software";
    hompage = "https://www.malighting.com";
    license = lib.licenses.unfree;
  };
})
