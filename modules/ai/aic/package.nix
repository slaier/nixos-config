{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aic";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "shenxiangzhuang";
    repo = "aic";
    rev = "0fc428381743eb744ec8ab5e45d549d0c6b8cc6c";
    hash = "sha256-TuMV2vS0/jWXlk915gqbSguAhscMaQeiqEwF4n3PUdw=";
  };

  cargoHash = "sha256-XGabI/F7/hNZTMY0U23Yg5VlrG6wV1SgDs7iaTTuPtY=";

  nativeBuildInputs = [ git ];

  doCheck = true;
  cargoTestFlags = "-- --test-threads=1";

  meta = {
    description = "CLI tool that uses AI to generate meaningful commit messages by analyzing staged Git changes";
    homepage = "https://github.com/shenxiangzhuang/aic";
    license = lib.licenses.mit;
    mainProgram = "aic";
    platforms = lib.platforms.unix;
  };
})
