{ config, lib, pkgs, ... }:
let
  jq = "${pkgs.jq}/bin/jq";
  rofi = "${pkgs.rofi-wayland}/bin/rofi";

  # https://gist.github.com/lbonn/89d064cde963cfbacabd77e0d3801398
  sway-window-switcher = pkgs.writeTextFile {
    name = "sway-window-switcher";
    destination = "/bin/sway-window-switcher";
    executable = true;

    text = ''
      set -euo pipefail

      tree=$(swaymsg -t get_tree)
      readarray -t win_ids <<< "$(${jq} -r '.. | objects | select(has("app_id")) | .id' <<< "$tree")"
      readarray -t win_names <<< "$(${jq} -r '.. | objects | select(has("app_id")) | .name' <<< "$tree")"
      readarray -t win_types <<< "$(${jq} -r '.. | objects | select(has("app_id")) | .app_id // .window_properties.class' <<< "$tree")"

      switch () {
          local k
          read -r k
          swaymsg "[con_id=''${win_ids[$k]}] focus"
      }

      for k in $(seq 0 $((''${#win_ids[@]} - 1))); do
          echo -e "<span weight=\"bold\">''${win_types[$k]}</span> - ''${win_names[$k]}"
      done | ${rofi} -dmenu -markup-rows -i -p window -format i | switch
    '';
  };

  configStr = import ../config.nix {
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
      format = "/home {free}";
      path = "/home";
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
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
    ];
    extraSessionCommands = ''
      source /etc/profile
      test -f $HOME/.profile && source $HOME/.profile
      systemctl --user import-environment
    '';
  };

  environment.etc."sway/config".text = configStr;
  environment.etc."xdg/waybar/config".text = builtins.toJSON waybarConfig;
}
