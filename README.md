# nix-packages

Personal Nix packages and an overlay for packages not yet available in
nixpkgs, following the `pkgs/by-name` layout.

## Usage

Build a package from this repository:

```sh
nix build .#arima
```

Use the overlay from another flake:

```nix
nixpkgs.overlays = [ inputs.nix-packages.overlays.default ];
```

Package expressions are licensed under the repository license. Packaged
software retains its upstream license.

## OpenKnowledge

`nix build .#open-knowledge` builds the CLI, web editor and HTTP MCP server.
See [package notes](pkgs/by-name/op/open-knowledge/README.md) for upstream,
version pinning, the dependency security override and update steps.
