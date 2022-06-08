{ config, lib, ... }: {
  imports = [
    ./core
    ./fcitx
    ./i3
    ./users
  ];

  options.slaier.isDesktop = lib.mkEnableOption "desktop";
}

