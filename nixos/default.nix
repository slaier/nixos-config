{ config, lib, ... }: {
  imports = [
    ./core
    ./i3
    ./users
  ];

  options.slaier.isDesktop = lib.mkEnableOption "desktop";
}

