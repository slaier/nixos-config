{ config, pkgs, lib, ... }:
let
  configStr = import ../config.nix {
    menu = "${pkgs.rofi}/bin/rofi -show drun";
    window-menu = "${pkgs.rofi}/bin/rofi -show window";
    msg = "i3-msg";
    floating-modifier-mode = "";
    extraConfig = {
      pre = "# i3 config file (v4)";
      post = "";
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
