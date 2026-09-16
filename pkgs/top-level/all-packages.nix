final: prev:
{
  # Packages are discovered from pkgs/by-name/<first-two-letters>/<package>.
}
// prev.lib.concatMapAttrs (_: v: v) (
  prev.lib.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ../by-name;
  }
)
