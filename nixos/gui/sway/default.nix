{ config, lib, pkgs, ... }:
let
  jq = "${pkgs.jq}/bin/jq";
  rofi = "${pkgs.rofi-wayland}/bin/rofi";

  sway-window-switcher = pkgs.writeTextFile {
    name = "sway-window-switcher";
    destination = "/bin/sway-window-switcher";
    executable = true;

    text = ''
      swaymsg -t get_tree |
      ${jq} 'until(.type == "con";
              .focus[:2][-1] as $id | .nodes[] | select(.id == $id)) |
             select(.focused == false) | .id' |
      xargs -r -I{} swaymsg "[con_id={}] focus"
    '';
  };

  configStr = import ./config.nix {
    inherit lib pkgs;
    menu = "${rofi} -show drun";
    window-menu = "${sway-window-switcher}/bin/sway-window-switcher";
    msg = "swaymsg";
    floating-modifier-mode = "normal";
    extraConfig = {
      pre = "# sway config file";
      post = ''
        output * bg ${pkgs.nixos-artwork.wallpapers.dracula}/share/backgrounds/nixos/nix-wallpaper-dracula.png fill
        bar swaybar_command ${pkgs.waybar}/bin/waybar
        exec ${pkgs.mako}/bin/mako --default-timeout 3000
        include /etc/sway/config.d/*
      '';
    };
  };

  waybarConfig = {
    modules-left = [
      "sway/workspaces"
    ];
    modules-center = [ ];
    modules-right = [
      "pulseaudio"
      "network"
      "cpu"
      "memory"
      "disk"
      "disk#data"
      "temperature"
      "clock"
      "tray"
    ];
    pulseaudio = {
      format = "{volume}% ";
      format-muted = "muted ";
      on-click = "pavucontrol";
      tooltip = false;
    };
    network = {
      format = "{ipaddr}";
      tooltip = false;
    };
    cpu = {
      format = " {usage}%";
      tooltip = false;
    };
    memory = {
      format = " {used:0.1f}/{total:0.1f}G";
      tooltip = false;
    };
    disk = {
      format = "/nix {free}";
      path = "/nix";
      tooltip = false;
    };
    "disk#data" = {
      format = "/data {free}";
      path = "/data";
      tooltip = false;
    };
    temperature = {
      format = " {temperatureC}°C";
      hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
      critical-threshold = 80;
      tooltip = false;
    };
    clock = {
      format = "{:%Y-%m-%d %H:%M}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };
    tray = {
      spacing = 10;
    };
  };
in
{
  programs.fish.loginShellInit = ''
    set TTY1 (tty)
    [ "$TTY1" = "/dev/tty1" ] && exec sway
  '';

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
    ];
  };

  environment.etc."sway/config".text = configStr;
  environment.etc."xdg/waybar/config".text = builtins.toJSON waybarConfig;
}
