{ config, pkgs, lib, ... }:
with lib;
mkMerge [
  (mkIf config.services.xserver.enable {
    programs.adb.enable = true;
  })

  (mkIf (config.services.xserver.enable && !config.virtualisation.virtualbox.guest.enable) {
    virtualisation.virtualbox.host.enable = true;
  })

  (mkIf config.sound.enable {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  })
]

