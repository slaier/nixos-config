{ config, lib, ... }:
with lib;
mkMerge [
  (mkIf config.slaier.isDesktop {
    programs.adb.enable = true;
  })

  (mkIf (config.slaier.isDesktop && !config.virtualisation.virtualbox.guest.enable) {
    virtualisation.virtualbox.host.enable = true;
  })
]

