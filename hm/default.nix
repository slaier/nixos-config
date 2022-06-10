{ lib, ... }: {
  imports = [
    ./fcitx
    ./firefox
    ./git
    ./i3
    ./neovim
    ./rust
  ];

  options.slaier.isDesktop = lib.mkEnableOption "desktop";
}

