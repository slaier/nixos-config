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
    "adnauseam"
    "clearurls"
    "copy-link-text-webextension"
    "dictionary-anyvhere"
    "enhancer-for-youtube"
    "history-cleaner"
    "https-everywhere"
    "i-dont-care-about-cookies"
    "imagus"
    "keepassxc-browser"
    "new_tongwentang"
    "offline-qr-code-generator"
    "rsshub-radar"
    "ublacklist"
    "undoclosetabbutton"
    "violentmonkey"
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
