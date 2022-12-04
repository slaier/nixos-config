{ config, pkgs, lib, ... }:
with lib;
let
  profilesPath =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/Firefox/Profiles"
    else
      ".mozilla/firefox";
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      adnauseam
      clearurls
      enhancer-for-youtube
      history-cleaner
      https-everywhere
      i-dont-care-about-cookies
      keepassxc-browser
      localcdn
      offline-qr-code-generator
      ublacklist
      violentmonkey
    ] ++ (with pkgs.nur.repos.bandithedoge.firefoxAddons; [
      imagus
    ]) ++ (with pkgs.nur.repos.slaier.firefox-addons; [
      copy-link-text-webextension
      dictionary-anyvhere
      new_tongwentang
      rsshub-radar
      undoclosetabbutton
    ]);
    profiles.default = {
      bookmarks = [
        {
          name = "Nix sites";
          bookmarks = [
            { name = "NUR search"; url = "https://nur.nix-community.org/"; }
            { name = "Nix Manual"; url = "https://nixos.org/manual/nix/stable/"; }
            { name = "Nixpkgs Manual"; url = "https://nixos.org/manual/nixpkgs/stable/"; }
            { name = "TVL"; url = "https://code.tvl.fyi/"; }
          ];
        }
        {
          name = "Learn";
          bookmarks = [
            { name = "Rust OS"; url = "https://learningos.github.io/rust-based-os-comp2022/"; }
            { name = "nLab"; url = "https://ncatlab.org/nlab/show/HomePage"; }
          ];
        }
        {
          name = "Collection";
          bookmarks = [
            { name = "ACGN"; url = "https://www.myiys.com/"; }
            { name = "MirrorZ"; url = "https://mirrorz.org/site"; }
            { name = "Pling"; url = "https://www.pling.com/"; }
          ];
        }
      ];
      extraConfig = ''
        ${fileContents "${pkgs.nur.repos.slaier.arkenfox-userjs}/user.js"}
        ${fileContents ./overlay.js}
      '';
      search = {
        default = "Google";
        engines = {
          "Amazon.com".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Google".metaData.alias = "@g";
          "NixOS packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "type"; value = "options"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "Home Manager options" = {
            urls = [{
              template = "https://mipmip.github.io/home-manager-option-search?{searchTerms}";
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@hm" ];
          };
        };
        force = true;
      };
    };
  };
  home.file."${profilesPath}/default/chrome" = {
    source = "${pkgs.nur.repos.slaier.material-fox}/chrome";
    recursive = true;
    force = true;
  };
}
