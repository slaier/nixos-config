# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      gfxmodeEfi = "1920x1080";
      gfxmodeBios = "1920x1080";
      efiSupport = true;
      useOSProber = true;
    };
  };

  networking.hostName = "pc";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  networking.firewall.enable = false;

  slaier = {
    isDesktop = true;
  };
}

