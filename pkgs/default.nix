{ pkgs }:
let
  sources = import ./_sources/generated.nix { inherit (pkgs) fetchurl fetchgit fetchFromGitHub; };
in
{
  material-fox = pkgs.callPackage ./tools/networking/material-fox { inherit sources; };
}

