{ super, src, ... }:
{ pkgs, ... }: {
  imports = map (x: x.default) (
    with src; [
      avahi
      clash
      common
      extlinux
      openfortivpn
      qinglong
      smartdns
      users
    ]
  );

  documentation.man.enable = false;
}
