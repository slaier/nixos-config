{ pkgs, ... }:
{
  imports = [
    ./core.nix
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

  programs.adb.enable = true;

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  environment.systemPackages = with pkgs; with indexyz; with nur.repos.slaier; [
    bottom
    cargo
    clang
    clash-speedtest
    distrobox
    dogdns
    hyperfine
    nali
    nvfetcher
    p7zip
    rustc
    tealdeer
    unrar
    unzip
    zip
  ];

  system.stateVersion = "22.05";
}
