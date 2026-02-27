{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "grandMA3-onPC";
  version = "2.3.2.0";

  src = pkgs.fetchzip {
    name = "grandMA3-v${finalAttrs.version}";
    url = "https://www.malighting.com/?eID=csForceDownload&download=YTo3OntzOjE6InUiO3M6MTI4OiJodHRwczovL3hvbS5tYWxpZ2h0aW5nLmNvbS94b20tcmVzdC9hc3NldHMvMzQ0NDYwZmMtMzJkYS00ZDlhLWFhNWQtMTU2Y2JjYWJkMGEzL2NvbnRlbnQ/YWNjZXNzX3Rva2VuPUpNZEdOUU1DY2FzT3NhUXBuNUNjOWpqZkF5SSI7czoxOiJtIjtzOjE1OiJhcHBsaWNhdGlvbi96aXAiO3M6MToiZiI7czoyNzoiZ3JhbmRNQTNfc3RpY2tfdjIuMy4yLjAuemlwIjtzOjE6ImUiO3M6MzoiWklQIjtzOjE6InMiO2I6MTtzOjE6ImMiO3M6ODoic29mdHdhcmUiO3M6MToibiI7YjowO30=";
    sha256 = "";
  };
})
