{ config, pkgs, lib, ... }:
lib.mkIf config.xsession.enable {
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      bars = [
        {
          colors = {
            activeWorkspace = {
              background = "#212121";
              border = "#212121";
              text = "#ffffff";
            };
            background = "#212121";
            bindingMode = {
              background = "#229c56";
              border = "#229c56";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              background = "#212121";
              border = "#212121";
              text = "#86888c";
            };
            separator = "#666666";
            statusline = "#dddddd";
            urgentWorkspace = {
              background = "#d64e4e";
              border = "#d64e4e";
              text = "#ffffff";
            };
          };
          fonts = {
            names = [ "'Noto Sans CJK SC'" ];
          };
          trayOutput = null;
        }
      ];
      floating.border = 0;
      floating.criteria = [
        { window_role = "app"; }
        { window_role = "pop-up"; }
        { window_role = "task_dialog"; }
        { title = "Preferences$"; }
      ];
      focus.followMouse = false;
      fonts = {
        names = [ "'Noto Sans CJK SC'" ];
      };
      gaps = {
        inner = 8;
        outer = 2;
        smartGaps = true;
      };
      keybindings = lib.mkOptionDefault {
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
      startup = [
        { command = "keepassxc"; always = true; notification = false; }
        { command = "stretchly"; always = true; notification = false; }
        { command = "quiterss"; always = true; notification = false; }
      ];
      terminal = "--no-startup-id ${pkgs.alacritty}/bin/alacritty";
      window.border = 0;
    };
  };
}

