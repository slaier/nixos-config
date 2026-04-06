{ pkgs, ... }:
{
  imports =
    [
      { programs.command-not-found.enable = false; }
      ./hardware-configuration.nix
    ];

  home-manager.users.nixos.imports = [
    ({ lib, ... }: {
      xdg.configFile."pip/pip.conf".text = lib.generators.toINI { } {
        global = {
          index-url = "https://mirror.nju.edu.cn/pypi/web/simple";
        };
      };
    })
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];
  boot.supportedFilesystems = [ "ntfs" ];

  networking = {
    firewall.enable = false;
    proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,.lan";
    };
  };

  documentation.man.generateCaches = false;

  nix.settings = {
    cores = 11;
    keep-outputs = true;
  };
  services.earlyoom.enable = true;

  services.speechd.enable = false;

  programs.adb.enable = true;
  programs.nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    # dailyuse
    abiword
    gnumeric
    kodi-wayland
    localsend
    nomacs
    pavucontrol
    qalculate-qt
    qbittorrent-enhanced
    qpdfview
    satty
    scrcpy
    ungoogled-chromium
    # development
    arduino-ide
    filezilla
    freerdp
    # cli
    alacritty
    bottom
    cloudflared
    curl
    doggo
    gdu
    geo
    git
    hydra-check
    hyperfine
    ianny
    iotop
    jq
    just
    killall
    librespeed-cli
    lsof
    meld
    minicom
    mtr
    nali
    neovim
    nix-tree
    nixpkgs-fmt
    p7zip
    pciutils
    python3
    qrencode
    ripgrep
    rust-petname
    sops
    unrar
    unzip
    usbutils
    wget
    xdg-utils
    ydict
    yq-go
    yt-dlp
    zip
  ];
  nixpkgs.config.chromium.commandLineArgs = "--enable-wayland-ime --wayland-text-input-version=3";
}
