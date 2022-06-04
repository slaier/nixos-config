{ pkgs, lib, packages, ... }:
let
  theme = (packages.material-fox);

  cfgPath = ".mozilla/firefox";
  profileName = "j9v3rvaj.default";
  profilePath = "${cfgPath}/${profileName}";
in
{
  home.packages = [ pkgs.firefox ];
  home.file = {
    "${cfgPath}/profiles.ini" = {
      text = ''
        [Profile0]
        Name=default
        IsRelative=1
        Path=${profileName}
        Default=1
        [General]
        StartWithLastProfile=1
        Version=2
      '';
    };

    "${profilePath}/user.js" = {
      source = "${theme}/user.js";
    };

    "${profilePath}/chrome" = {
      source = "${theme}/chrome";
      recursive = true;
    };
  };
}

