# OpenKnowledge

Packages the official `@inkeep/open-knowledge` npm release (CLI, HTTP MCP server
and web editor) without rebuilding the frontend. Upstream:
<https://github.com/inkeep/open-knowledge>.

```sh
nix build .#open-knowledge
./result/bin/ok --version
mkdir -p /tmp/knowledge-example
./result/bin/ok --cwd /tmp/knowledge-example init --no-mcp --no-skills --shared
./result/bin/ok --cwd /tmp/knowledge-example start --no-open-browser
```

Node.js 24 and Git are supplied by Nix. The release contains native modules;
only the target's glibc helper is retained and its ELF dependencies are patched
to Nix paths. The package supports Linux x86_64 and aarch64; x86_64 is the
deployment target tested for Sirius.

## Dependency override

The 0.86.16 release requests `simple-git ^3.36.0`, which is affected by the
unsafe Git configuration/argument handling advisories
[GHSA-x6jw-m9v5-85vh](https://github.com/advisories/GHSA-x6jw-m9v5-85vh) and
[GHSA-858h-whjf-mvg5](https://github.com/advisories/GHSA-858h-whjf-mvg5).
This expression pins `simple-git 4.0.2`; the lock file records the complete
dependency graph. npm audit reported no vulnerabilities after the override.
Recheck whether the override is needed when updating upstream.

## Updating

1. Download the desired official npm tarball into a temporary directory and
   verify its npm integrity. Update `version` and the source SHA-256.
2. Extract it, remove `devDependencies` from `package.json`, and apply the same
   dependency adjustment as `postPatch`. Generate `package-lock.json` with
   Node.js 24's `npm install --package-lock-only --ignore-scripts --omit=dev`.
   Do not install npm packages globally.
3. Copy the lock file here, set `npmDepsHash = lib.fakeHash`, build once, then
   use the reported actual hash and rebuild. Run npm audit on the new lock.
4. Verify the version, project initialization, web editor, and an MCP
   write/read/delete round trip. A successful build alone is insufficient.

Application documents and writable state belong outside the Nix store.
