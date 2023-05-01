{ nodes, config, lib, pkgs, src, ... }: {
  imports = map (x: x.default) (
    with src; [
      avahi
      clash
      common
      extlinux
      nix
      openfortivpn
      qinglong
      smartdns
      users
    ]
  );

  nix.settings = {
    substituters = lib.mkForce [
      "http://local.local:5000"
    ];
    trusted-public-keys = lib.mkForce [
      "local.local-1:rkw0zf/GEln2K7PKAkMH2JtJfaACnMXEl1OGteT1AHE="
    ];
  };

  documentation.man.enable = false;
}
