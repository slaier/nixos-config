{ pkgs, sources, ... }: with pkgs;
stdenv.mkDerivation {
  inherit (sources.material-fox) pname version src;

  installPhase = ''
    mkdir -p $out
    cp ./user.js $out/user.js
    cp -r ./chrome $out/chrome
  '';

  meta = with lib; {
    description = "A Material Design-inspired userChrome.css theme for Firefox.";
    homepage = "https://github.com/muckSponge/MaterialFox";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ slaier ];
  };
}

