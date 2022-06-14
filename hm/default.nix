{ lib, ... }: {
  imports = [
    ./apps
    ./fcitx
    ./firefox
    ./git
    ./i3
    ./neovim
    ./rust
    ./shell
    ./vscode
  ];

  options.slaier.isDesktop = lib.mkEnableOption "desktop";
}

