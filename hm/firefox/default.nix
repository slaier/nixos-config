{ config, pkgs, lib, ... }:
with lib;
let
  theme = (pkgs.nur.repos.slaier.material-fox);

  cfgPath = ".mozilla/firefox";

  profiles = let arkenfox-userjs = fileContents "${pkgs.nur.repos.slaier.arkenfox-userjs}/user.js"; in
    {
      default = {
        id = 0;
        extraConfig = arkenfox-userjs + (fileContents ./default.js);
      };
      cn = {
        id = 1;
        extraConfig = arkenfox-userjs + (fileContents ./default.js) + (fileContents ./cn.js);
      };
    };

  profilesINI = (mapAttrs'
    (name: profile: nameValuePair "Profile${toString profile.id}" {
      Name = name;
      Path = name;
      IsRelative = 1;
      Default = if profile.id == 0 then 1 else 0;
    })
    profiles) // { General = { StartWithLastProfile = 1; }; };

  profilePaths = mapAttrsToList
    (name: profile: {
      "${cfgPath}/${name}/user.js".text = profile.extraConfig;
      "${cfgPath}/${name}/chrome" = {
        source = "${theme}/chrome";
        recursive = true;
      };
    })
    profiles;
  iniPath = {
    "${cfgPath}/profiles.ini".text = generators.toINI { } profilesINI;
  };

  extensions = [
    "https-everywhere"
    "violentmonkey"
    "new_tongwentang"
    "keepassxc-browser"
    "adnauseam"
    "rsshub-radar"
    "ublacklist"
    "clearurls"
    "enhancer-for-youtube"
    "copy-link-text-webextension"
    "history-cleaner"
    "imagus"
    "i-dont-care-about-cookies"
    "cookie-autodelete"
    "undoclosetabbutton"
    "offline-qr-code-generator"
  ];
  xpis = lib.lists.forEach extensions (extension:
    "https://addons.mozilla.org/firefox/downloads/latest/${extension}/latest.xpi"
  );
in
{
  home.packages = [
    (pkgs.wrapFirefox pkgs.firefox-unwrapped {
      forceWayland = true;
      extraPolicies = {
        Extensions = {
          Install = xpis;
        };
      };
    })
  ];
  home.file = mkMerge ([ iniPath ] ++ profilePaths);
}

