{
  lib,
  stdenvNoCC,
  requireFile,
  unzip,
  libxml2,
  makeWrapper,
  autoPatchelfHook,
  systemdLibs,
  libunwind,
  alsa-lib,
  libX11,
  libxrandr,
  libxi,
  libxxf86vm,
  libxinerama,
  libxcursor,
  libGL,
  libgcc,
  libdrm,
  SDL2,
  libxv,
  libxext,
  libva,
  bzip2,
  gnutls,
  fontconfig,
  freetype,
  avahi,
  nss,
  at-spi2-atk,
  libxcomposite,
  libxdamage,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grandMA3-onPC";
  version = "2.3.2.0";
  shortVersion = "2.3.2";
  system = "x86_64-linux";

  src = requireFile {
    # currently must add the zip manually using
    # nix-store --add grandMA3_stick_vX.X.X.X.zip
    name = "grandMA3_stick_v2.3.2.0.zip";
    url = "https://www.malighting.com/downloads/products/grandma3/";
    sha256 = "4bff734150e5fd43409930cf7e1a8d0e95ed7f6bdbec55afb55de989beec56a3";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    libxml2
    makeWrapper
    autoPatchelfHook
  ];

  autoPatchelfIgnoreMissingDeps = [ "libprocps.so.8" ];

  buildInputs = [
    systemdLibs
    libunwind
    alsa-lib
    libX11
    libxrandr
    libxi
    libxxf86vm
    libxinerama
    libxcursor
    libGL
    libgcc
    libdrm
    SDL2
    libxv
    libxext
    libva
    bzip2
    gnutls
    fontconfig
    freetype
    avahi
    nss
    at-spi2-atk
    libxcomposite
    libxdamage
  ];

  postUnpack = ''
    cd ma

    # reads the xml manifest file and unzips and creates directories and then
    # unzips the required files
    xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@Destination' ./release_stick_*.xml | sed "s/ Destination=/mkdir -p /" | sed "s|/home/ma|$out|" | sh
    xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@*[name()="Name" or name()="Destination"]' ./release_stick_*.xml | sed "s/ Destination=/ -d /" | tr -d "\n" | sed "s/ Name=/\nunzip -o /g" | sed "s|/home/ma|$out|" | sh

    # contains some shared libraries, put them in a spot where autopatchelf can see
    cp -r $out/MALightingTechnology/gma3_${finalAttrs.shortVersion}/shared/third_party $out/lib
  '';

  # buildPhase = ''

  #   ls -l $src
  #   ls -l $out
  # '';

  installPhase =
    let
      versionPath = "MALightingTechnology/gma3_${finalAttrs.shortVersion}";
    in
    ''
      mkdir -p $out/bin

      makeWrapper "$out/${versionPath}/console/bin/app_gma3" "$out/bin/gma3" \
        --set HOSTTYPE onPC
    '';

  meta = {
    description = "Lighting control software";
    hompage = "https://www.malighting.com";
    # license = lib.licenses.unfree;
  };
})
