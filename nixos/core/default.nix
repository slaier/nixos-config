{ config, pkgs, lib, ... }:
with lib;
mkMerge [
  {
    nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
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

    system.stateVersion = "22.05";
  }

  (mkIf config.slaier.isDesktop {
    programs.adb.enable = true;
  })
]

