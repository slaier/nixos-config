{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vbox";

  services.openssh.enable = true;

  networking.firewall.enable = false;

  slaier = {
    isDesktop = true;
  };
}

