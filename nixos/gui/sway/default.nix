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

        include /etc/sway/config.d/*
      '';
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
  };

  environment.etc."sway/config".text = configStr;
}
