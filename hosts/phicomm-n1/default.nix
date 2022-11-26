{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos/core
    ../../nixos/users
    ../../nixos/services/qinglong
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  services.openssh.enable = true;

  networking.hostName = "n1";
}
