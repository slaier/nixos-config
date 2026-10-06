{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs_22,
  python3,
  runCommand,
}:

let
  version = "0.8.5";
  src = fetchFromGitHub {
    owner = "AmintaCCCP";
    repo = "GithubStarsManager";
    rev = "v${version}";
    hash = "sha256-yDqHTYCo4bfs9wZVhHJam6yTpTz4IrWoktTIbU0JjtU=";
  };

  # upstream lockfile requests babel-plugin-polyfill-corejs3@^0.13.0 but only
  # pins 0.14.2, which `npm ci` rejects; align the spec with the pinned version
  srcPatched = runCommand "githubstarsmanager-src-patched" { } ''
    cp -r ${src} $out
    chmod -R u+w $out
    sed -i 's|"babel-plugin-polyfill-corejs3": "^0.13.0"|"babel-plugin-polyfill-corejs3": "^0.14.2"|' $out/package-lock.json
  '';

  frontend = buildNpmPackage {
    pname = "githubstarsmanager-frontend";
    inherit version;
    src = srcPatched;
    nodejs = nodejs_22;
    npmDeps = fetchNpmDeps {
      inherit version;
      src = srcPatched;
      hash = "sha256-RuQOziGVCKaP+eWdT19gUPpsJb/jsem3BoPvVk8qtAQ=";
    };
    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  server = buildNpmPackage {
    pname = "githubstarsmanager-server";
    inherit version src;
    nodejs = nodejs_22;
    sourceRoot = "source/server";
    npmDepsHash = "sha256-Tq/OBWtZUlHZ2idJxIq/1vv/xJm/jWj2J0vMLp5+Id0=";
    nativeBuildInputs = [ python3 ];
    postBuild = "npm prune --omit=dev";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/dist
      cp -r node_modules $out/node_modules
      cp package.json $out/package.json
      cp -r ${frontend} $out/public
      # local-only deployment: let /api/proxy reach loopback/private targets
      # (e.g. local llama.cpp); upstream only allows them with a saved outbound proxy config
      sed -i 's|const allowPrivate = Boolean(configId);|const allowPrivate = true;|' $out/dist/routes/proxy.js
      runHook postInstall
    '';
  };
in
server
