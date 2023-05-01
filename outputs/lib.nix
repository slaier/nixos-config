{ lib, inputs, ... }:
with lib;
{
  eachDefaultSystems = f: genAttrs
    [
      "aarch64-linux"
      "x86_64-linux"
    ]
    (system: f (import inputs.nixpkgs { inherit system; }));

  collectBlock = name: set:
    let
      recCollectBlock = name: set: foldl
        (acc: n: acc ++ (
          let v = set.${n}; in
          if v ? ${name} then
            [ (nameValuePair n v.${name}) ]
          else
            concatLists (optional (isAttrs v) (recCollectBlock name v))
        ))
        [ ]
        (attrNames set);
    in
    builtins.listToAttrs (recCollectBlock name set);
}
