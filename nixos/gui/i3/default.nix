{ config, pkgs, lib, ... }:
let
  configStr = import ../config.nix {
    menu = "${pkgs.rofi}/bin/rofi -show drun";
    window-menu = "${pkgs.rofi}/bin/rofi -show window";
    msg = "i3-msg";
    floating-modifier-mode = "";
    extraConfig = {
      pre = "# i3 config file (v4)";
      post = ''
        bar {
          position top
          status_command while date +'%Y-%m-%d %I:%M:%S %p'; do sleep 1; done
          colors {
              statusline #ffffff
              background #323232
              inactive_workspace #32323200 #32323200 #5c5c5c
          }
        }
        exec --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ${../minecraft.png}
      '';
    };
  };
in
{
  services.xserver = {
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      configFile = pkgs.writeText "config" configStr;
    };
  };
}
