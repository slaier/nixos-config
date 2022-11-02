final: prev: {
  podman-compose = prev.podman-compose.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "containers";
      repo = "podman-compose";
      rev = "08ffcf6126a3ae4016e3d81e963a3629e4b75986";
      sha256 = "sha256-ybdwBc//clXQ8WHG3lfGP4g8VLECFvEWSnVxZxjhLLU=";
    };
  });
}
