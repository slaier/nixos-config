{ config, lib, pkgs, ... }:
let
  configStr = import ./config.nix { inherit lib pkgs; };

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
  environment.etc."xdg/swayr/config.toml".text = import ./swayr.nix { inherit lib pkgs; };
}
