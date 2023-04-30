{ inputs, src, ... }:
{ config, pkgs, ... }:
let
  modules = with src; [
    avahi
    bluetooth
    clash
    common
    fcitx5
    firefox
    fish
    fonts
    genymotion
    git
    grub
    gtk
    neovim
    nix
    nix-serve
    pipewire
    podman
    safeeyes
    smartdns
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
    proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,.local";
    };
  };

  nix.settings.max-jobs = 11;
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
    pciutils
    quiterss
    tdesktop
    tealdeer
    unrar
    unzip
    usbutils
    vlc
    wget
    xdg-utils
    yt-dlp
    zip
    (src.lib.wrapper.makeNoProxyWrapper {
      name = "ydict";
      pkg = ydict;
      inherit symlinkJoin makeWrapper;
    })
    (src.lib.wrapper.makeNoProxyWrapper {
      name = "vivaldi";
      pkg = callPackage (inputs.nixpkgs-unstable + "/pkgs/applications/networking/browsers/vivaldi/default.nix") {
        proprietaryCodecs = true;
        enableWidevine = true;
        commandLineArgs = [
          "--ozone-platform-hint=auto"
          "--enable-features=WaylandWindowDecorations"
        ];
      };
      inherit symlinkJoin makeWrapper;
    })
    config.nur.repos.slaier.motrix
    config.nur.repos.xddxdd.qbittorrent-enhanced-edition
  ];

  environment.etc."sway/config.d/misc.conf".text = ''
    for_window [app_id="keepassxc"] floating enable
    exec --no-startup-id XDG_SESSION_TYPE=x11 qbittorrent
    exec --no-startup-id gammastep -l 31:121
  '';
}
