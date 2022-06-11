{ lib, ... }: {
  imports = [
    ./apps
    ./fcitx
    ./firefox
    ./git
    ./i3
    ./neovim
    ./rust
    ./vscode
  ];

  options.slaier.isDesktop = lib.mkEnableOption "desktop";
}

