{ pkgs, ... }:
{
  imports = [
    ./core.nix
  ];

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

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.GBK/GBK"
    "zh_CN.UTF-8/UTF-8"
    "zh_CN/GB2312"
  ];

  programs.adb.enable = true;
  programs.command-not-found.dbPath = "${pkgs.nur.repos.slaier.programs-db}/programs.sqlite";

  slaier.services.clash = with pkgs.nur.repos.slaier; {
    enable = true;
    dashboard.path = yacd;
    geoip.path = "${clash-geoip}/etc/clash/Country.mmdb";
  };

  environment.systemPackages = with pkgs; [
    bottom
    croc
    dogdns
    hydra-check
    hyperfine
    just
    killall
    librespeed-cli
    nali
    nix-tree
    nixpkgs-fmt
    nvfetcher
    p7zip
    tealdeer
    unrar
    unzip
    zip
  ];
}
