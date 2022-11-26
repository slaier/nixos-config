final: prev: {
  qemu = prev.qemu.overrideAttrs (o: {
    patches = o.patches ++ [
      (prev.fetchpatch {
        name = "qemu-9p-performance-fix.patch";
        url = "https://gitlab.com/lheckemann/qemu/-/commit/8ab70b8958a8f9cb9bd316eecd3ccbcf05c06614.patch";
        sha256 = "sha256-PSOv0dhiEq9g6B1uIbs6vbhGr7BQWCtAoLHnk4vnvVg=";
      })
    ];
  });
}
