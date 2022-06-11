{ config, pkgs, lib, ... }:
with lib;
mkMerge [
  {
    home.packages = with pkgs; with indexyz; [
      bottom
      dogdns
      hyperfine
      nali
      p7zip
      tealdeer
      thefuck
      unrar
      unzip
      zip
    ];
  }
  (mkIf config.slaier.isDesktop {
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

