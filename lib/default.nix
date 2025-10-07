{ lib }:
with lib;
rec {
  /* Make a package set detectable by various Nix tools.

     Example:
       x = with pkgs; { y = { inherit hello; }; z = { inherit bash; }; }
       makeRecurseIntoAttrs x
       => {
            recurseForDerivations = true;
            y = {
              hello = «derivation ...»;
              recurseForDerivations = true;
            };
            z = {
              bash = «derivation ...»;
              recurseForDerivations = true;
            };
          }

     Type:
       makeRecurseIntoAttrs :: AttrSet -> AttrSet
  */
  makeRecurseIntoAttrs = set:
    let
      g =
        name: value:
        if !isAttrs value || isDerivation value then
          value
        else
          makeRecurseIntoAttrs value;
    in
    recurseIntoAttrs (mapAttrs g set);

  /* Flatten a package set.

     Example:
       x = with pkgs; { y = { inherit jq; }; z = { inherit curl; }; }
       flattenPackageSet "devshell" x
       => { devshell-y-jq = «derivation ...»; devshell-z-curl = «derivation ...»; }

     Type:
       flattenPackageSet :: String -> AttrSet -> AttrSet
  */
  flattenPackageSet =
    # The package set name.
    name:
    collectYield isDerivation (path: v: { ${concatStringsSep "-" ([ name ] ++ path)} = v; });

  /* Recursively collect yielded items that verify a given predicate named
     `pred` from the set `attrs`. The recursion is stopped when the predicate
     is verified.

     Example:
       collectYield (v: v ? outPath) (path: v: { ${last path} = v; })
          { a = { outPath = "a/"; }; c = { b = { outPath = "b/"; }; }; }
       => { a = { outPath = "a/"; }; b = { outPath = "b/"; }; }

     Type:
       collectYield :: (AttrSet -> Bool) -> (String -> AttrSet -> AttrSet) -> AttrSet -> AttrSet
  */
  collectYield =
    # Given an attribute's value, determine if recursion should stop.
    pred:
    # Given an attribute's path and value, yield an attr set when the predicate
    # is verified.
    f:
    let
      recurse = path: set:
        foldl'
          (acc: n: acc // (
            let
              v = set.${n};
              newPath = path ++ [ n ];
            in
            if pred v then
              f newPath v
            else
              optionalAttrs (isAttrs v) (recurse newPath v)
          ))
          { }
          (attrNames set);
    in
    recurse [ ];

  /* Recursively collect attr sets that `hasAttr` the given block name. The
     block name is stripped.

     Example:
       collectBlock "outPath"
          { a = { outPath = "a/"; }; c = { b = { outPath = "b/"; }; }; }
       => { a = "a/"; b = "b/"; }

     Type:
       collectBlock :: String -> AttrSet -> AttrSet
  */
  collectBlock =
    # The block name to collect.
    name:
    collectYield (v: v ? ${name}) (path: v: { ${last path} = v.${name}; });

  /* Remove override attrs added by callPackage. */
  removeOverrideAttrs = set: builtins.removeAttrs set [ "override" "overrideDerivation" ];

  /* Make a package set after callPackage.

     Example:
       makePackageSet (pkgs.callPackage ./firefox-addons { })
       => { addon-0 = «derivation ...»; addon-1 = «derivation ...»; recurseForDerivations = true; }

     Type:
       makePackageSet :: AttrSet -> AttrSet
   */
  makePackageSet = set: makeRecurseIntoAttrs (removeOverrideAttrs set);

  /**
    Recursively collects all values from a nested attribute set into a single list.

    @param attrset The attribute set to traverse.
    @return A list containing all the values from the attribute set.

    Example:
    recursiveValuesToList {
      a = 1;
      b = {
        c = 2;
        d = "hello";
      };
      e = [ 3 4 ];
    }
    => [ 1 2 "hello" [ 3 4 ] ]
  */
  recursiveValuesToList = attrset:
    let
      values = builtins.attrValues attrset;
    in
    builtins.concatLists (map
      (value:
        if builtins.isAttrs value then
          recursiveValuesToList value
        else
          [ value ]
      )
      values);

  # Recursively flattens an attribute set.
  # Example:
  #   flattenAttrset {
  #     a.b = 1;
  #     c.d = 2;
  #   }
  #   => { b = 1; d = 2; }
  flattenAttrset = attrs:
    foldl'
      (acc: name:
        let
          value = attrs.${name};
        in
        if isAttrs value && !(isDerivation value) then
          acc // flattenAttrset value
        else
          acc // { ${name} = value; }
      )
      { }
      (builtins.attrNames attrs);

  fromDirectoryRecursive = { directory, filename, transformer, ... }@args:
    let
      inherit (lib.path) append;
      inherit (lib) concatMapAttrs;
      defaultPath = append directory filename;
    in
    if builtins.pathExists defaultPath then
    # if `${directory}/${filename}` exists, call it directly
      transformer defaultPath
    else
      concatMapAttrs
        (
          name: type:
            # for each directory entry
            let
              path = append directory name;
            in
            if type == "directory" then
              {
                # recurse into directories
                "${name}" = fromDirectoryRecursive (
                  args
                  // {
                    directory = path;
                  }
                );
              }
            else
              {
                # ignore files
              }
        )
        (builtins.readDir directory);
}
