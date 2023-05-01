{ super, modules, lib, ... }:
with super.lib;
let
  packages = collectBlock "package" modules;
in
eachDefaultSystems (pkgs: lib.mapAttrs
  (name: package: pkgs.callPackage package { })
  packages)
