{ super, src, ... }:
{ pkgs, ... }: {
  imports = map (x: x.default) (
    with src; [
      common
      tools.clash
      users.nixos
      tools.extlinux
      virtualisation.openfortivpn
      virtualisation.qinglong
    ]
  );

  documentation.man.enable = false;
}
