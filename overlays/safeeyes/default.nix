final: prev: {
  safeeyes = prev.safeeyes.overrideAttrs (old:
    let
      version = "2.1.4";
    in
    assert (builtins.compareVersions old.version version) == -1;
    {
      inherit version;
      src = prev.python3.pkgs.fetchPypi {
        inherit (old) pname;
        inherit version;
        sha256 = "sha256-SsZRyODeYRQk2pVspKzfJbSRX/zjD+M+aaK+YXPu6CE=";
      };
    });
}
