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

  services.sshd.enable = true;

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
  programs.command-not-found.dbPath = "${pkgs.nur.repos.slaier.programs-db}/programs.sqlite";

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  slaier.services.clash = with pkgs.nur.repos.slaier; {
    enable = true;
    dashboard.path = yacd;
    geoip.path = "${clash-geoip}/etc/clash/Country.mmdb";
  };

  environment.systemPackages = with pkgs; [
    bottom
    clang
    dogdns
    hyperfine
    nali
    nvfetcher
    p7zip
    tealdeer
    unrar
    unzip
    zip
  ];

  system.stateVersion = "22.05";
}
