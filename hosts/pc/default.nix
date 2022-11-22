# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixos/core
    ../../nixos/gui
    ../../nixos/users
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

  networking.hostName = "pc";
  networking.firewall.enable = false;
  networking.proxy = {
    default = "http://pc.lan:7890";
    noProxy = "127.0.0.1,localhost,192.168.0.0/16";
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    clang
    colmena
  ];

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

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
}
