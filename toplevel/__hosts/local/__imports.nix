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
  fcitx5
  firefox
  safeeyes
  spotify
  sway
  vscode
  waybar
]) ++
(with tools; [
  clash
  fish
  git
  grub
  neovim
  nix-index
])
