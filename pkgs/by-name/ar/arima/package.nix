{
  lib,
  fetchFromGitHub,
  stdenvNoCC,

  # passthru
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "arima";
  version = "0-unstable-2023-02-20";

  src = fetchFromGitHub {
    owner = "NDISCOVER";
    repo = "Arima-Font";
    rev = "c5fd72960f129076fbf3759d6d777cedcbceb468";
    hash = "sha256-qbyy3F8cg49rJeTuYSehGJ6l5T1desYlbOadyDEocs0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -dm755 "$out/share/fonts/truetype"
    install -Dm644 fonts/static/ttf/*.ttf -t "$out/share/fonts/truetype"
    install -Dm644 OFL.txt "$out/share/licenses/arima/OFL.txt"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Tamil, Malayalam, and Latin display font family with a calligraphic feel";
    homepage = "https://github.com/NDISCOVER/Arima-Font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
