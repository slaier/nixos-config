{ pkgs, ... }:
{
  imports = [
    ./core.nix
    ./minor_core.nix
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

  documentation.nixos.enable = false;

  system.stateVersion = "22.05";
}

