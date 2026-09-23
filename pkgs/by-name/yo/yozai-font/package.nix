{
  lib,
  fetchurl,
  stdenvNoCC,
}:

let
  version = "0.868";
  src = "https://github.com/lxgw/yozai-font/releases/download/v${version}";

  fonts = [
    {
      name = "Yozai-Light.ttf";
      hash = "sha256-DvyEMwiBDATsOU2K8n0Ica2jqcxIYKImq96Iobxns70=";
    }
    {
      name = "Yozai-Regular.ttf";
      hash = "sha256-JQcZmKD+anL1TCNecUmG0lljPl/2cLGiteJkOH8zFqw=";
    }
    {
      name = "Yozai-Medium.ttf";
      hash = "sha256-BfUPJStFGX0NYUikq8PjfHzUz98DyVW1fCXVPZJPg18=";
    }
  ];
in
stdenvNoCC.mkDerivation {
  pname = "yozai-font";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -dm755 "$out/share/fonts/truetype"
    ${lib.concatMapStringsSep "\n" (font: ''
      install -Dm644 ${fetchurl {
        url = "${src}/${font.name}";
        inherit (font) hash;
      }} "$out/share/fonts/truetype/${font.name}"
    '') fonts}

    install -Dm644 ${./OFL.txt} "$out/share/licenses/yozai-font/OFL.txt"

    runHook postInstall
  '';

  meta = {
    description = "Chinese handwriting font derived from YozFont";
    homepage = "https://github.com/lxgw/yozai-font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
