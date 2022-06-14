{ config, pkgs, lib, ... }:
with lib;
mkMerge [
  {
    nix.settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://slaier.cachix.org"
        "https://indexyz.cachix.org"
        "https://nrdxp.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "slaier.cachix.org-1:NyXPOqlxuGWgyn0ApNHMopkbix3QjMUAcR+JOjjxLtU="
        "indexyz.cachix.org-1:biBEnuZ4vTSsVMr8anZls+Lukq8w4zTHAK8/p+fdaJQ="
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    environment.systemPackages = with pkgs; [
      curl
      git
      neovim
      wget
    ];

    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        nerdfonts
        noto-fonts-cjk
        noto-fonts-emoji
      ];

      fontconfig = {
        defaultFonts = {
          serif = [ "FantasqueSansMono Nerd Font Mono" ];
          sansSerif = [ "FantasqueSansMono Nerd Font Mono" ];
          monospace = [ "FantasqueSansMono Nerd Font Mono" "Noto Color Emoji" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };

    services.earlyoom.enable = true;

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "40960";
      }
    ];

    time.timeZone = "Asia/Shanghai";
    time.hardwareClockInLocalTime = true;

    system.stateVersion = "22.05";
  }

  (mkIf config.slaier.isDesktop {
    programs.adb.enable = true;
  })

  (mkIf (config.slaier.isDesktop && !config.virtualisation.virtualbox.guest.enable) {
    virtualisation.virtualbox.host.enable = true;
  })
]

