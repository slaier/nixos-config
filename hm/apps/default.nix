{ config, pkgs, lib, ... }:
with lib;
mkMerge [
  {
    home.packages = with pkgs; with indexyz; with nur.repos.slaier; [
      bottom
      clash-speedtest
      dogdns
      hyperfine
      nali
      nvfetcher
      p7zip
      tealdeer
      thefuck
      unrar
      unzip
      zip
    ];
  }
  (mkIf config.xsession.enable {
    home.packages = with pkgs; with indexyz; [
      gimp
      keepassxc
      libreoffice-fresh
      motrix
      okular
      quiterss
      spotify
      stretchly
      tdesktop
      vlc
    ];
  })
]

