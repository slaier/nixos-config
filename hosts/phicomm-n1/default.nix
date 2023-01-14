{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos/core/core.nix
    ../../nixos/users
    ../../nixos/services/openfortivpn
    ../../nixos/services/qinglong
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  services.openssh.enable = true;

  networking.hostName = "n1";
  networking.firewall.allowedTCPPorts = [
    3333 # yacd
    7890 # http_proxy
    9090 # clashctl
  ];
  slaier.services.clash = with pkgs.nur.repos.slaier; {
    enable = true;
    dashboard.path = yacd;
    geoip.path = "${clash-geoip}/etc/clash/Country.mmdb";
  };

  documentation.man.enable = false;
  documentation.doc.enable = false;
}
