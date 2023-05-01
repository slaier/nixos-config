{ lib, modules, ... }:
with lib;
let
  collectBlock = name: set: foldl
    (acc: n: acc ++ (
      let v = set.${n}; in
      if v ? ${name} then
        [ (nameValuePair n v.${name}) ]
      else
        concatLists (optional (isAttrs v) (collectBlock name v))
    ))
    [ ]
    (attrNames set);
  overlays = listToAttrs (collectBlock "overlay" modules);
in
overlays
