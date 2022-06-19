{ config, lib, ... }:
lib.mkIf config.services.xserver.enable {
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
    };
  };
}

