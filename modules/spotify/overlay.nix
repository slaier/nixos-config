final: prev: {
  spotifywm = prev.spotifywm.overrideAttrs (self: {
    propagatedBuildInputs = [ ];
    installPhase = ''
      install -Dm644 spotifywm.so $out/lib/spotifywm.so
    '';
  });
  spotify = prev.spotify.overrideAttrs (self: {
    installPhase = builtins.replaceStrings
      [ ''--prefix LD_LIBRARY_PATH : "$librarypath"'' ]
      [ ''--prefix LD_LIBRARY_PATH : "$librarypath" --prefix LD_PRELOAD : "${final.spotifywm}/lib/spotifywm.so"'' ]
      self.installPhase;
  });
}
