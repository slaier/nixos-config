{ inputs, src, ... }:
{ config, pkgs, ... }:
let
  modules = with src; [
    bluetooth
    clash
    common
    fcitx5
    firefox
    fish
    fonts
    git
    grub
    gtk
    https-dns-proxy
    neovim
    pipewire
    podman
    safeeyes
    spotify
    sway
    users
    vscode
    waybar
  ];
in
{
  imports = map (x: x.default or { }) modules ++
    (with inputs; [
      (nixpkgs-unstable + "/nixos/modules/programs/nix-index.nix")
      nix-index-database.nixosModules.nix-index
      { programs.command-not-found.enable = false; }
    ]);

  home-manager = {
    users.nixos = {
      imports = map (x: x.home or { }) modules;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];
  boot.supportedFilesystems = [ "ntfs" ];

  networking = {
    firewall.enable = false;
    nameservers = [ "127.0.0.1" ];
    search = [ "lan" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,lan,dict.youdao.com";
    };
  };

  services.earlyoom.enable = true;

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    bottom
    clang
    colmena
    croc
    curl
    dogdns
    gammastep
    git
    hydra-check
    hyperfine
    just
    keepassxc
    killall
    librespeed-cli
    nali
    neovim
    nix-tree
    nixpkgs-fmt
    nvfetcher
    okular
    p7zip
    pavucontrol
    quiterss
    tdesktop
    tealdeer
    unrar
    unzip
    vlc
    wget
    xdg-utils
    ydict
    yt-dlp
    zip
    config.nur.repos.slaier.motrix
    config.nur.repos.xddxdd.qbittorrent-enhanced-edition
  ];

  environment.etc."sway/config.d/misc.conf".text = ''
    for_window [app_id="keepassxc"] floating enable
    exec --no-startup-id XDG_SESSION_TYPE=x11 qbittorrent
    exec --no-startup-id gammastep -l 31:121
  '';
}
