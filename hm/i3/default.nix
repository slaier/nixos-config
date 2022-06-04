{ lib, pkgs, ... }: with lib; {
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      floating.border = 0;
      focus.followMouse = false;
      gaps = {
        inner = 8;
        outer = 2;
        smartGaps = true;
      };
      keybindings = mkOptionDefault {
        "${modifier}+Tab" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show window";
        "${modifier}+Shift+a" = "focus child";
        "${modifier}+Shift+h" = "move absolute position center";
        "${modifier}+Shift+m" = "move position mouse";
        "${modifier}+Shift+s" = "sticky toggle";
        "${modifier}+Shift+p" = "fullscreen disable; floating enable; resize set 350 px 197 px; sticky enable; move window to position 1006 px 537 px";
        "${modifier}+t" = "border normal 0";
        "${modifier}+y" = "border pixel 1";
        "${modifier}+u" = "border none";
      };
      menu = "--no-startup-id ${pkgs.rofi}/bin/rofi -show drun";
      modifier = "Mod4"; # use win key
      terminal = "--no-startup-id ${pkgs.alacritty}/bin/alacritty";
      window.border = 0;
    };
  };
}

