{ src, ... }:
with src;
[
  common
  data.fonts
  hardware.bluetooth
  libraries.gtk
  libraries.pipewire
  services.https-dns-proxy
  users.nixos
  virtualisation.podman
] ++
(with applications; [
  firefox
  safeeyes
  spotify
  sway
  waybar
  vscode
]) ++
(with tools; [
  clash
  fcitx5
  fish
  git
  grub
  neovim
  nix-index
])
