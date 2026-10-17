{
  lib,
  stdenv,
  buildNpmPackage,
  fetchurl,
  nodejs_24,
  autoPatchelfHook,
  makeWrapper,
  git,
  cacert,
  libsecret,
}:

buildNpmPackage (finalAttrs: {
  pname = "open-knowledge";
  version = "0.86.16";

  src = fetchurl {
    url = "https://registry.npmjs.org/@inkeep/open-knowledge/-/open-knowledge-${finalAttrs.version}.tgz";
    hash = "sha256-PzXLuzeN3RjIOYX2fayhKQ/glTXoLuYz4tM0XnyK9CE=";
  };

  nodejs = nodejs_24;
  npmDepsHash = "sha256-05sMw+Y/FIExxjiA6hj3XGVYwXtUdVxoDwq7RcAy6mw=";
  npmFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    libsecret
  ];

  postPatch = ''
    # The official npm release already contains the CLI, server and web editor.
    # 4.0.2 fixes simple-git's unsafe configuration/argument handling advisories.
    ${lib.getExe nodejs_24} -e 'const fs = require("fs"); const p = require("./package.json"); delete p.devDependencies; p.dependencies["simple-git"] = "4.0.2"; fs.writeFileSync("package.json", JSON.stringify(p, null, 2) + "\n");'
    cp ${./package-lock.json} package-lock.json

    # Keep only the native configuration helper for this target.
    find dist/native -name '*.node' ! -name 'native-config.linux-${
      if stdenv.hostPlatform.isx86_64 then "x64" else "arm64"
    }-gnu.node' -delete
  '';

  postFixup = ''
    for program in ok open-knowledge; do
      wrapProgram "$out/bin/$program" \
        --prefix PATH : ${lib.makeBinPath [ git ]} \
        --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt \
        --set-default SSL_CERT_DIR ${cacert}/etc/ssl/certs
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME="$TMPDIR" "$out/bin/ok" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Local-first Markdown knowledge base with a web editor and MCP server";
    homepage = "https://github.com/inkeep/open-knowledge";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ok";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
})
