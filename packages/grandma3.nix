{
  lib,
  stdenvNoCC,
  requireFile,
  unzip,
  libxml2,
  makeWrapper,
  auto-patchelf,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grandMA3-onPC";
  version = "2.3.2.0";
  shortVersion = "2.3.2";
  system = "x86_64-linux";

  src = requireFile {
    name = "grandMA3_stick_v2.3.2.0.zip";
    url = "https://www.malighting.com/downloads/products/grandma3/";
    sha256 = "4bff734150e5fd43409930cf7e1a8d0e95ed7f6bdbec55afb55de989beec56a3";
  };

  nativeBuildInputs = [
    unzip
    libxml2
    makeWrapper
    auto-patchelf
  ];

  sourceRoot = ".";

  postUnpack = ''
    cd ma

    xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@Destination' ./release_stick_*.xml | sed "s/ Destination=/mkdir -p /" | sed "s|/home/ma|$out|" | sh
    xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@*[name()="Name" or name()="Destination"]' ./release_stick_*.xml | sed "s/ Destination=/ -d /" | tr -d "\n" | sed "s/ Name=/\nunzip -o /g" | sed "s|/home/ma|$out|" | sh
  '';

  buildPhase = ''

    ls -l $src
    ls -l $out
  '';

  installPhase =
    let
      versionPath = "MALightingTechnology/gma3_${finalAttrs.shortVersion}";
    in
    ''
      mkdir -p $out/bin

      makeWrapper "$out/${versionPath}/console/bin/app_gma3" "$out/bin/gma3" \
        --set HOSTTYPE onPC \
        --prefix LD_LIBRARY_PATH : $out/${versionPath}/shared/third_party
    '';

  meta = {
    description = "Lighting control software";
    hompage = "https://www.malighting.com";
    license = lib.licenses.unfree;
  };
})
